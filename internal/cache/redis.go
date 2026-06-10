package cache

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"diplomaBackend/internal/logger"

	"github.com/redis/go-redis/v9"
)

type Cache struct {
	client *redis.Client
	ttl    time.Duration
}

func NewRedisCache(addr, password string, db int, ttl time.Duration) *Cache {
	if addr == "" {
		return nil
	}

	client := redis.NewClient(&redis.Options{
		Addr:     addr,
		Password: password,
		DB:       db,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	if err := client.Ping(ctx).Err(); err != nil {
		logger.Warn("redis cache disabled: ping failed: %v", err)
		_ = client.Close()
		return nil
	}

	logger.Info("redis cache connected: addr=%s db=%d", addr, db)

	return &Cache{
		client: client,
		ttl:    ttl,
	}
}

func (c *Cache) GetJSON(ctx context.Context, key string, dest any) bool {
	if c == nil || c.client == nil {
		return false
	}

	value, err := c.client.Get(ctx, key).Result()
	if err != nil {
		if !errors.Is(err, redis.Nil) {
			logger.Warn("redis get failed: key=%s err=%v", key, err)
		}
		return false
	}

	if err := json.Unmarshal([]byte(value), dest); err != nil {
		logger.Warn("redis unmarshal failed: key=%s err=%v", key, err)
		return false
	}

	return true
}

func (c *Cache) SetJSON(ctx context.Context, key string, value any) {
	if c == nil || c.client == nil {
		return
	}

	bytes, err := json.Marshal(value)
	if err != nil {
		logger.Warn("redis marshal failed: key=%s err=%v", key, err)
		return
	}

	if err := c.client.Set(ctx, key, bytes, c.ttl).Err(); err != nil {
		logger.Warn("redis set failed: key=%s err=%v", key, err)
	}
}

func (c *Cache) Close() {
	if c != nil && c.client != nil {
		_ = c.client.Close()
	}
}

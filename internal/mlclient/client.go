package mlclient

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

type Client interface {
	RankNextTopics(ctx context.Context, req NextTopicRankRequest) (*NextTopicRankResponse, error)
	RankRepetition(ctx context.Context, req RepetitionRankRequest) (*RepetitionRankResponse, error)
}

type HTTPClient struct {
	baseURL    string
	httpClient *http.Client
}

func NewHTTPClient(baseURL string) *HTTPClient {
	return &HTTPClient{
		baseURL: strings.TrimRight(baseURL, "/"),
		httpClient: &http.Client{
			Timeout: 2 * time.Second,
		},
	}
}

func (c *HTTPClient) RankNextTopics(ctx context.Context, req NextTopicRankRequest) (*NextTopicRankResponse, error) {
	var result NextTopicRankResponse

	if err := c.postJSON(ctx, "/rank/next-topics", req, &result); err != nil {
		return nil, err
	}

	return &result, nil
}

func (c *HTTPClient) RankRepetition(ctx context.Context, req RepetitionRankRequest) (*RepetitionRankResponse, error) {
	var result RepetitionRankResponse

	if err := c.postJSON(ctx, "/rank/repetition", req, &result); err != nil {
		return nil, err
	}

	return &result, nil
}

func (c *HTTPClient) postJSON(ctx context.Context, path string, reqBody any, result any) error {
	body, err := json.Marshal(reqBody)
	if err != nil {
		return err
	}

	httpReq, err := http.NewRequestWithContext(
		ctx,
		http.MethodPost,
		c.baseURL+path,
		bytes.NewReader(body),
	)
	if err != nil {
		return err
	}

	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(httpReq)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode >= 300 {
		return fmt.Errorf("ml service returned status %d", resp.StatusCode)
	}

	if err := json.NewDecoder(resp.Body).Decode(result); err != nil {
		return err
	}

	return nil
}

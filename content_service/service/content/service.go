package content

import (
	"context"
	"diplomaBackend/internal/cache"
	"fmt"

	"diplomaBackend/content_service/dto"
	"diplomaBackend/content_service/repository"
	"diplomaBackend/content_service/service"
	"diplomaBackend/internal/logger"
)

type Service struct {
	contentRepo repository.ContentRepository
	cache       *cache.Cache
}

func NewService(contentRepo repository.ContentRepository, cache *cache.Cache) service.ContentService {
	return &Service{
		contentRepo: contentRepo,
		cache:       cache,
	}
}

func (s *Service) ListTopics(ctx context.Context, languageCode string) ([]dto.TopicResponse, error) {

	cacheKey := fmt.Sprintf("content:topics:%s", languageCode)
	endpoint := "GET /api/content/topics"

	var cachedTopics []dto.TopicResponse
	if s.cache.GetJSON(ctx, cacheKey, &cachedTopics) {
		logger.Info("cache hit: endpoint=%s key=%s language_code=%s", endpoint, cacheKey, languageCode)
		return cachedTopics, nil
	}

	logger.Info("cache miss: endpoint=%s key=%s language_code=%s", endpoint, cacheKey, languageCode)

	topics, err := s.contentRepo.ListTopics(ctx, languageCode)
	if err != nil {
		logger.Error("content service: failed to list topics: language_code=%s err=%v", languageCode, err)
		return nil, err
	}

	s.cache.SetJSON(ctx, cacheKey, topics)
	logger.Info("cache set: endpoint=%s key=%s language_code=%s", endpoint, cacheKey, languageCode)

	return topics, nil
}

func (s *Service) ListSubtopicsByTopicCode(ctx context.Context, topicCode, languageCode string) (*dto.TopicSubtopicsResponse, error) {

	cacheKey := fmt.Sprintf("content:topic:%s:subtopics:%s", topicCode, languageCode)
	endpoint := "GET /api/content/topics/{topicCode}/subtopics"

	var cachedResponse dto.TopicSubtopicsResponse
	if s.cache.GetJSON(ctx, cacheKey, &cachedResponse) {
		logger.Info(
			"cache hit: endpoint=%s key=%s topic_code=%s language_code=%s",
			endpoint,
			cacheKey,
			topicCode,
			languageCode,
		)
		return &cachedResponse, nil
	}

	logger.Info(
		"cache miss: endpoint=%s key=%s topic_code=%s language_code=%s",
		endpoint,
		cacheKey,
		topicCode,
		languageCode,
	)

	subtopics, err := s.contentRepo.ListSubtopicsByTopicCode(ctx, topicCode, languageCode)
	if err != nil {
		logger.Error(
			"content service: failed to list subtopics: topic_code=%s language_code=%s err=%v",
			topicCode,
			languageCode,
			err,
		)
		return nil, err
	}

	finalQuiz, err := s.contentRepo.GetTopicFinalQuizByTopicCode(ctx, topicCode, languageCode)
	if err != nil {
		logger.Error(
			"content service: failed to get topic final quiz: topic_code=%s language_code=%s err=%v",
			topicCode,
			languageCode,
			err,
		)
		return nil, err
	}

	response := &dto.TopicSubtopicsResponse{
		Subtopics: subtopics,
		FinalQuiz: finalQuiz,
	}

	s.cache.SetJSON(ctx, cacheKey, response)
	logger.Info(
		"cache set: endpoint=%s key=%s topic_code=%s language_code=%s",
		endpoint,
		cacheKey,
		topicCode,
		languageCode,
	)

	return response, nil
}

func (s *Service) GetLessonBySubtopicCode(ctx context.Context, subtopicCode, languageCode string) (*dto.LessonResponse, error) {
	cacheKey := fmt.Sprintf("content:subtopic:%s:lesson:%s", subtopicCode, languageCode)
	endpoint := "GET /api/content/subtopics/{subtopicCode}/lesson"

	var cachedLesson dto.LessonResponse
	if s.cache.GetJSON(ctx, cacheKey, &cachedLesson) {
		logger.Info(
			"cache hit: endpoint=%s key=%s subtopic_code=%s language_code=%s",
			endpoint,
			cacheKey,
			subtopicCode,
			languageCode,
		)
		return &cachedLesson, nil
	}

	logger.Info(
		"cache miss: endpoint=%s key=%s subtopic_code=%s language_code=%s",
		endpoint,
		cacheKey,
		subtopicCode,
		languageCode,
	)

	lesson, err := s.contentRepo.GetLessonBySubtopicCode(ctx, subtopicCode, languageCode)
	if err != nil {
		logger.Error(
			"content service: failed to get lesson: subtopic_code=%s language_code=%s err=%v",
			subtopicCode,
			languageCode,
			err,
		)
		return nil, err
	}

	s.cache.SetJSON(ctx, cacheKey, lesson)
	logger.Info(
		"cache set: endpoint=%s key=%s subtopic_code=%s language_code=%s",
		endpoint,
		cacheKey,
		subtopicCode,
		languageCode,
	)
	
	return lesson, nil
}

package repository

import (
	"context"

	"diplomaBackend/content_service/dto"
)

type ContentRepository interface {
	ListTopics(ctx context.Context, languageCode string) ([]dto.TopicResponse, error)
	ListSubtopicsByTopicCode(ctx context.Context, topicCode, languageCode string) ([]dto.SubtopicResponse, error)
	GetLessonBySubtopicCode(ctx context.Context, subtopicCode, languageCode string) (*dto.LessonResponse, error)
}

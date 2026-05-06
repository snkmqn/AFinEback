package service

import (
	"context"

	"diplomaBackend/adaptation_service/dto"
)

type ProcessQuizResultInput struct {
	UserID       int64
	QuizID       int64
	AttemptID    int64
	QuizType     string
	TopicCode    *string
	SubtopicCode *string
	ScorePercent float64
}

type AdaptationService interface {
	ProcessQuizResult(ctx context.Context, input ProcessQuizResultInput) (*dto.ReinforcementResponse, error)
}

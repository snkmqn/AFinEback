package adaptation

import (
	"context"

	"diplomaBackend/adaptation_service/dto"
	"diplomaBackend/adaptation_service/model"
	"diplomaBackend/adaptation_service/repository"
	"diplomaBackend/adaptation_service/service"
	"diplomaBackend/internal/logger"
	"diplomaBackend/internal/mlclient"
)

type Service struct {
	adaptationRepo repository.AdaptationRepository
	mlClient       mlclient.Client
}

func NewService(
	adaptationRepo repository.AdaptationRepository,
	mlClient mlclient.Client,
) service.AdaptationService {
	return &Service{
		adaptationRepo: adaptationRepo,
		mlClient:       mlClient,
	}
}

func (s *Service) ProcessQuizResult(ctx context.Context, input service.ProcessQuizResultInput) (*dto.ReinforcementResponse, error) {
	features, err := s.adaptationRepo.GetReinforcementFeatures(ctx, input.UserID, input.AttemptID)
	if err != nil {
		return nil, err
	}

	if features.QuizScore >= 75 && features.AvgLast3Scores >= 70 {
		result := &dto.ReinforcementResponse{
			NeedsReinforcement: false,
			Prediction:         0,
			Probability:        0,
			Confidence:         1,
			DecisionSource:     "rule_strong_result",
			ModelName:          "rule_based",
		}

		if err := s.savePrediction(ctx, input, features, result); err != nil {
			logger.Error(
				"adaptation service: failed to save reinforcement prediction: user_id=%d attempt_id=%d err=%v",
				input.UserID,
				input.AttemptID,
				err,
			)
		}

		return result, nil
	}

	if s.mlClient == nil {
		result := fallbackReinforcement(features)

		if err := s.savePrediction(ctx, input, features, result); err != nil {
			logger.Error(
				"adaptation service: failed to save fallback reinforcement prediction: user_id=%d attempt_id=%d err=%v",
				input.UserID,
				input.AttemptID,
				err,
			)
		}

		return result, nil
	}

	mlResult, err := s.mlClient.PredictReinforcement(ctx, mlclient.ReinforcementPredictRequest{
		UserLevel:              features.UserLevel,
		LearningGoal:           features.LearningGoal,
		TopicCode:              features.TopicCode,
		SubtopicCode:           features.SubtopicCode,
		TopicLevel:             features.TopicLevel,
		QuizType:               features.QuizType,
		QuizScore:              features.QuizScore,
		AvgLast3Scores:         features.AvgLast3Scores,
		PreviousFailsSameTopic: features.PreviousFailsSameTopic,
		SubtopicOrder:          features.SubtopicOrder,
		PreferredTopicMatch:    features.PreferredTopicMatch,
		CompletedInteractive:   features.CompletedInteractive,
	})
	if err != nil {
		logger.Error(
			"adaptation service: failed to call ML service: user_id=%d attempt_id=%d err=%v",
			input.UserID,
			input.AttemptID,
			err,
		)

		result := fallbackReinforcement(features)

		if err := s.savePrediction(ctx, input, features, result); err != nil {
			logger.Error(
				"adaptation service: failed to save fallback reinforcement prediction: user_id=%d attempt_id=%d err=%v",
				input.UserID,
				input.AttemptID,
				err,
			)
		}

		return result, nil
	}

	result := &dto.ReinforcementResponse{
		NeedsReinforcement: mlResult.NeedsReinforcement,
		Prediction:         mlResult.Prediction,
		Probability:        mlResult.Probability,
		Confidence:         mlResult.Confidence,
		DecisionSource:     "ml",
		ModelName:          mlResult.ModelName,
	}

	if err := s.savePrediction(ctx, input, features, result); err != nil {
		logger.Error(
			"adaptation service: failed to save reinforcement prediction: user_id=%d attempt_id=%d err=%v",
			input.UserID,
			input.AttemptID,
			err,
		)
	}

	return result, nil
}

func fallbackReinforcement(features *model.ReinforcementFeatures) *dto.ReinforcementResponse {
	needs := true

	if features.QuizScore >= 75 && features.AvgLast3Scores >= 70 {
		needs = false
	}

	prediction := 0
	if needs {
		prediction = 1
	}

	return &dto.ReinforcementResponse{
		NeedsReinforcement: needs,
		Prediction:         prediction,
		Probability:        0,
		Confidence:         0,
		DecisionSource:     "fallback_rule",
		ModelName:          "rule_based",
	}
}

func (s *Service) savePrediction(
	ctx context.Context,
	input service.ProcessQuizResultInput,
	features *model.ReinforcementFeatures,
	result *dto.ReinforcementResponse,
) error {
	if result == nil {
		return nil
	}

	return s.adaptationRepo.SaveReinforcementPrediction(ctx, &model.ReinforcementPrediction{
		UserID:    input.UserID,
		QuizID:    input.QuizID,
		AttemptID: input.AttemptID,

		QuizType:     features.QuizType,
		TopicCode:    features.TopicCode,
		SubtopicCode: features.SubtopicCode,

		ScorePercent:   features.QuizScore,
		AvgLast3Scores: features.AvgLast3Scores,

		NeedsReinforcement: result.NeedsReinforcement,
		Prediction:         result.Prediction,
		Probability:        result.Probability,
		Confidence:         result.Confidence,

		DecisionSource: result.DecisionSource,
		ModelName:      result.ModelName,
		ModelVersion:   "",
	})
}

package repository

import (
	"context"

	"diplomaBackend/adaptation_service/model"
)

type AdaptationRepository interface {
	GetReinforcementFeatures(ctx context.Context, userID, attemptID int64) (*model.ReinforcementFeatures, error)
	SaveReinforcementPrediction(ctx context.Context, prediction *model.ReinforcementPrediction) error
}

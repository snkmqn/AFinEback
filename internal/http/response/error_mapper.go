package response

import (
	profileErrors "diplomaBackend/user_profile_service/errors"
	"errors"
	"net/http"

	authErrors "diplomaBackend/authorization_service/errors"
)

type AppError struct {
	Status int
	Code   string
}

func MapError(err error) AppError {
	switch {
	case err == nil:
		return AppError{
			Status: http.StatusInternalServerError,
			Code:   "INTERNAL_ERROR",
		}

	case errors.Is(err, authErrors.ErrEmptyUsername),
		errors.Is(err, authErrors.ErrEmptyEmail),
		errors.Is(err, authErrors.ErrInvalidEmailFormat),
		errors.Is(err, authErrors.ErrEmptyPassword),
		errors.Is(err, authErrors.ErrPasswordTooShort),
		errors.Is(err, authErrors.ErrPasswordMustHaveDigit),
		errors.Is(err, authErrors.ErrPasswordInvalidChars),
		errors.Is(err, authErrors.ErrUsernameTooShort),
		errors.Is(err, authErrors.ErrUsernameTooLong),
		errors.Is(err, authErrors.ErrUsernameBadSymbols),
		errors.Is(err, authErrors.ErrUsernameSameAsCurrent),
		errors.Is(err, authErrors.ErrInvalidUsername),
		errors.Is(err, authErrors.ErrPasswordSameAsCurrent):
		return AppError{
			Status: http.StatusBadRequest,
			Code:   err.Error(),
		}

	case errors.Is(err, authErrors.ErrEmailAlreadyExists),
		errors.Is(err, authErrors.ErrGoogleEmailAlreadyExists):
		return AppError{
			Status: http.StatusConflict,
			Code:   err.Error(),
		}

	case errors.Is(err, authErrors.ErrInvalidCredentials),
		errors.Is(err, authErrors.ErrInvalidRefreshToken),
		errors.Is(err, authErrors.ErrRefreshTokenExpired),
		errors.Is(err, authErrors.ErrRefreshTokenRevoked),
		errors.Is(err, authErrors.ErrRefreshTokenNotFound),
		errors.Is(err, authErrors.ErrInvalidGoogleToken):
		return AppError{
			Status: http.StatusUnauthorized,
			Code:   err.Error(),
		}

	case errors.Is(err, authErrors.ErrInactiveUser),
		errors.Is(err, authErrors.ErrGoogleEmailNotVerified):
		return AppError{
			Status: http.StatusForbidden,
			Code:   err.Error(),
		}

	case errors.Is(err, authErrors.ErrUserNotFound),
		errors.Is(err, authErrors.ErrOAuthAccountNotFound):
		return AppError{
			Status: http.StatusNotFound,
			Code:   err.Error(),
		}

	case errors.Is(err, profileErrors.ErrProfileNotFound):
		return AppError{
			Status: http.StatusNotFound,
			Code:   err.Error(),
		}

	case errors.Is(err, profileErrors.ErrSettingsNotFound):
		return AppError{
			Status: http.StatusNotFound,
			Code:   err.Error(),
		}

	case errors.Is(err, profileErrors.ErrPreferredTopicsRequired):
		return AppError{
			Status: http.StatusBadRequest,
			Code:   err.Error(),
		}

	case errors.Is(err, profileErrors.ErrInvalidFinancialLiteracyLevel),
		errors.Is(err, profileErrors.ErrInvalidPracticalExperience),
		errors.Is(err, profileErrors.ErrInvalidLearningGoal),
		errors.Is(err, profileErrors.ErrInvalidPreferredLanguage),
		errors.Is(err, profileErrors.ErrInvalidTimeCommitment),
		errors.Is(err, profileErrors.ErrInvalidPreferredTopic),
		errors.Is(err, profileErrors.ErrInvalidTheme),
		errors.Is(err, profileErrors.ErrInvalidReminderTime):
		return AppError{
			Status: http.StatusBadRequest,
			Code:   err.Error(),
		}

	case errors.Is(err, authErrors.ErrTooManyLoginAttempts):
		return AppError{
			Status: http.StatusTooManyRequests,
			Code:   err.Error(),
		}
		
	default:
		return AppError{
			Status: http.StatusInternalServerError,
			Code:   "INTERNAL_ERROR",
		}
	}
}

func WriteAppError(w http.ResponseWriter, err error) {
	appErr := MapError(err)
	WriteError(w, appErr.Status, appErr.Code)
}

package app

import (
	userProfileHandler "diplomaBackend/user_profile_service/handler"
	"net/http"

	"diplomaBackend/authorization_service/handler"
	authPostgres "diplomaBackend/authorization_service/repository/postgres"
	authService "diplomaBackend/authorization_service/service/auth"
	googleverifier "diplomaBackend/authorization_service/service/google"
	jwtservice "diplomaBackend/authorization_service/service/jwt"
	passwordservice "diplomaBackend/authorization_service/service/password"
	"diplomaBackend/internal/config"
	"diplomaBackend/internal/http/middleware"
	storagePostgres "diplomaBackend/internal/storage/postgres"
	userProfilePostgres "diplomaBackend/user_profile_service/repository/postgres"
	userProfileService "diplomaBackend/user_profile_service/service/user"

	"github.com/jackc/pgx/v5/pgxpool"
)

type App struct {
	db     *pgxpool.Pool
	router http.Handler
}

func New(cfg *config.Config) *App {
	db := storagePostgres.New(cfg.DatabaseURL)
	authTxManager := authPostgres.NewTxManager(db)

	userRepo := authPostgres.NewUserRepository(db)
	refreshTokenRepo := authPostgres.NewRefreshTokenRepository(db)
	oauthAccountRepo := authPostgres.NewOAuthAccountRepository(db)
	userLoginSecurityRepo := authPostgres.NewUserLoginSecurityRepository(db)

	profileRepo := userProfilePostgres.NewProfileRepository(db)
	preferredTopicRepo := userProfilePostgres.NewPreferredTopicRepository(db)
	settingsRepo := userProfilePostgres.NewSettingsRepository(db)

	profileTxManager := userProfilePostgres.NewTxManager(db)

	profileSvc := userProfileService.NewService(
		profileRepo,
		preferredTopicRepo,
		settingsRepo,
		profileTxManager,
	)

	profileHandler := userProfileHandler.NewHandler(profileSvc)

	passwordSvc := passwordservice.NewService()
	jwtSvc := jwtservice.NewService(cfg.JWTAccessSecret, cfg.AccessTokenTTL)
	googleVerifier := googleverifier.NewVerifier(cfg.GoogleClientID)

	authSvc := authService.NewService(
		userRepo,
		refreshTokenRepo,
		oauthAccountRepo,
		userLoginSecurityRepo,
		passwordSvc,
		jwtSvc,
		googleVerifier,
		authTxManager,
		cfg.RefreshTokenTTL,
	)

	authHandler := handler.NewAuthHandler(authSvc)
	authMiddleware := middleware.AuthMiddleware(jwtSvc)

	router := middleware.CORS(NewRouter(authHandler, profileHandler, authMiddleware))

	return &App{
		db:     db,
		router: router,
	}
}

func (a *App) Router() http.Handler {
	return a.router
}

func (a *App) Close() {
	if a.db != nil {
		a.db.Close()
	}
}

package app

import (
	"net/http"

	"diplomaBackend/authorization_service/handler"
	profileHandler "diplomaBackend/user_profile_service/handler"
)

func NewRouter(
	authHandler *handler.AuthHandler,
	profileHandler *profileHandler.Handler,
	authMiddleware func(http.Handler) http.Handler,
) http.Handler {
	apiMux := http.NewServeMux()

	apiMux.HandleFunc("POST /auth/register", authHandler.Register)
	apiMux.HandleFunc("POST /auth/login", authHandler.Login)
	apiMux.HandleFunc("POST /auth/google", authHandler.GoogleLogin)
	apiMux.HandleFunc("POST /auth/refresh", authHandler.Refresh)
	apiMux.HandleFunc("POST /auth/logout", authHandler.Logout)

	apiMux.Handle("GET /auth/me", authMiddleware(http.HandlerFunc(authHandler.Me)))
	apiMux.Handle("PATCH /auth/me/username", authMiddleware(http.HandlerFunc(authHandler.ChangeUsername)))
	apiMux.Handle("PATCH /auth/me/password", authMiddleware(http.HandlerFunc(authHandler.ChangePassword)))

	apiMux.Handle("GET /profile/me", authMiddleware(http.HandlerFunc(profileHandler.GetProfile)))
	apiMux.Handle("PUT /profile/me", authMiddleware(http.HandlerFunc(profileHandler.UpsertProfile)))
	apiMux.Handle("GET /profile/settings", authMiddleware(http.HandlerFunc(profileHandler.GetSettings)))
	apiMux.Handle("PATCH /profile/settings", authMiddleware(http.HandlerFunc(profileHandler.UpdateSettings)))

	rootMux := http.NewServeMux()
	rootMux.Handle("/api/", http.StripPrefix("/api", apiMux))

	return rootMux
}

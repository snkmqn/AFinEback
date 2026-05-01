package handler

import (
	"net/http"

	"diplomaBackend/content_service/service"
	"diplomaBackend/internal/http/response"
)

type Handler struct {
	service service.ContentService
}

func NewHandler(service service.ContentService) *Handler {
	return &Handler{service: service}
}

func getLanguageCode(r *http.Request) string {
	lang := r.URL.Query().Get("lang")

	switch lang {
	case "ru", "kk", "en":
		return lang
	default:
		return "kk"
	}
}

func (h *Handler) ListTopics(w http.ResponseWriter, r *http.Request) {
	languageCode := getLanguageCode(r)

	res, err := h.service.ListTopics(r.Context(), languageCode)
	if err != nil {
		response.WriteAppError(w, err)
		return
	}

	response.WriteJSON(w, http.StatusOK, res)
}

func (h *Handler) ListSubtopicsByTopicCode(w http.ResponseWriter, r *http.Request) {
	topicCode := r.PathValue("topicCode")
	if topicCode == "" {
		response.WriteError(w, http.StatusBadRequest, "INVALID_TOPIC_CODE")
		return
	}

	languageCode := getLanguageCode(r)

	res, err := h.service.ListSubtopicsByTopicCode(r.Context(), topicCode, languageCode)
	if err != nil {
		response.WriteAppError(w, err)
		return
	}

	response.WriteJSON(w, http.StatusOK, res)
}

func (h *Handler) GetLessonBySubtopicCode(w http.ResponseWriter, r *http.Request) {
	subtopicCode := r.PathValue("subtopicCode")
	if subtopicCode == "" {
		response.WriteError(w, http.StatusBadRequest, "INVALID_SUBTOPIC_CODE")
		return
	}

	languageCode := getLanguageCode(r)
	
	res, err := h.service.GetLessonBySubtopicCode(r.Context(), subtopicCode, languageCode)
	if err != nil {
		response.WriteAppError(w, err)
		return
	}

	response.WriteJSON(w, http.StatusOK, res)
}

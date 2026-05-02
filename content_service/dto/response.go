package dto

import "encoding/json"

type TopicResponse struct {
	Code        string `json:"code"`
	Level       string `json:"level"`
	OrderIndex  int    `json:"orderIndex"`
	Title       string `json:"title"`
	Description string `json:"description,omitempty"`
}

type SubtopicResponse struct {
	Code             string `json:"code"`
	OrderIndex       int    `json:"orderIndex"`
	EstimatedMinutes *int   `json:"estimatedMinutes,omitempty"`
	Title            string `json:"title"`
	Description      string `json:"description,omitempty"`
}

type TopicFinalQuizResponse struct {
	QuizID           int64  `json:"quizId"`
	TopicCode        string `json:"topicCode"`
	QuizType         string `json:"quizType"`
	Title            string `json:"title"`
	PassingScore     int    `json:"passingScore"`
	TimeLimitSeconds *int   `json:"timeLimitSeconds,omitempty"`
}

type TopicSubtopicsResponse struct {
	Subtopics []SubtopicResponse      `json:"subtopics"`
	FinalQuiz *TopicFinalQuizResponse `json:"finalQuiz,omitempty"`
}

type LessonStepResponse struct {
	ID                 int64           `json:"id"`
	StepType           string          `json:"stepType"`
	OrderIndex         int             `json:"orderIndex"`
	Title              *string         `json:"title,omitempty"`
	Content            json.RawMessage `json:"content"`
	InteractiveType    *string         `json:"interactiveType,omitempty"`
	InteractiveContent json.RawMessage `json:"interactiveContent,omitempty"`
}

type LessonResponse struct {
	LessonID      int64                `json:"lessonId"`
	TopicCode     string               `json:"topicCode"`
	TopicTitle    string               `json:"topicTitle"`
	TopicLevel    string               `json:"topicLevel"`
	SubtopicCode  string               `json:"subtopicCode"`
	SubtopicTitle string               `json:"subtopicTitle"`
	Steps         []LessonStepResponse `json:"steps"`
}

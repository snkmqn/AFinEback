package mlclient

type ReinforcementPredictRequest struct {
	UserLevel              string  `json:"user_level"`
	LearningGoal           string  `json:"learning_goal"`
	TopicCode              string  `json:"topic_code"`
	SubtopicCode           string  `json:"subtopic_code"`
	TopicLevel             string  `json:"topic_level"`
	QuizType               string  `json:"quiz_type"`
	QuizScore              float64 `json:"quiz_score"`
	AvgLast3Scores         float64 `json:"avg_last_3_scores"`
	PreviousFailsSameTopic int     `json:"previous_fails_same_topic"`
	SubtopicOrder          int     `json:"subtopic_order"`
	PreferredTopicMatch    int     `json:"preferred_topic_match"`
	CompletedInteractive   int     `json:"completed_interactive"`
}

type ReinforcementPredictResponse struct {
	NeedsReinforcement bool    `json:"needs_reinforcement"`
	Prediction         int     `json:"prediction"`
	Probability        float64 `json:"probability"`
	Confidence         float64 `json:"confidence"`
	Threshold          float64 `json:"threshold,omitempty"`
	ModelName          string  `json:"model_name,omitempty"`
}

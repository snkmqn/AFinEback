package model

type RepetitionCandidate struct {
	ConceptCode            string
	TopicCode              *string
	UserSkillIndex         float64
	ConceptDifficultyIndex float64
	DaysSinceLastReview    float64
	ReviewCount            int
	RecallSuccessRate      float64
	LastRecallCorrect      int
	AverageLatencySeconds  float64
}

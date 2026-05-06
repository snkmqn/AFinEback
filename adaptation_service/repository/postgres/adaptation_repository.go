package postgres

import (
	"context"

	"diplomaBackend/adaptation_service/model"
	storagePostgres "diplomaBackend/internal/storage/postgres"
)

type AdaptationRepository struct {
	db storagePostgres.DBTX
}

func NewAdaptationRepository(db storagePostgres.DBTX) *AdaptationRepository {
	return &AdaptationRepository{db: db}
}

func (r *AdaptationRepository) GetReinforcementFeatures(ctx context.Context, userID, attemptID int64) (*model.ReinforcementFeatures, error) {
	query := `
		with current_attempt as (
			select
				qa.id as attempt_id,
				qa.user_id,
				qa.quiz_id,
				qa.score_percent::numeric as quiz_score,
				coalesce(q.quiz_type, 'subtopic_quiz') as quiz_type,
				coalesce(q.topic_code, t_from_subtopic.code) as topic_code,
				q.subtopic_code,
				topic.level as topic_level,
				coalesce(s.order_index, 5) as subtopic_order
			from quiz_attempts qa
			join quizzes q
				on q.id = qa.quiz_id
			left join subtopics s
				on s.code = q.subtopic_code
			left join topics t_from_subtopic
				on t_from_subtopic.id = s.topic_id
			join topics topic
				on topic.code = coalesce(q.topic_code, t_from_subtopic.code)
			where qa.id = $2
			  and qa.user_id = $1
			  and qa.status = 'completed'
		),
		last_3_scores as (
			select
				coalesce(avg(x.score_percent), (select quiz_score from current_attempt))::numeric as avg_last_3_scores
			from (
				select qa.score_percent
				from quiz_attempts qa
				join quizzes q
					on q.id = qa.quiz_id
				left join subtopics s
					on s.code = q.subtopic_code
				left join topics t_from_subtopic
					on t_from_subtopic.id = s.topic_id
				where qa.user_id = $1
				  and qa.status = 'completed'
				  and coalesce(q.topic_code, t_from_subtopic.code) = (select topic_code from current_attempt)
				order by coalesce(qa.completed_at, qa.submitted_at) desc, qa.id desc
				limit 3
			) x
		),
		previous_fails as (
			select
				count(*)::int as previous_fails_same_topic
			from quiz_attempts qa
			join quizzes q
				on q.id = qa.quiz_id
			left join subtopics s
				on s.code = q.subtopic_code
			left join topics t_from_subtopic
				on t_from_subtopic.id = s.topic_id
			where qa.user_id = $1
			  and qa.id <> $2
			  and qa.status = 'completed'
			  and qa.score_percent < 75
			  and coalesce(q.topic_code, t_from_subtopic.code) = (select topic_code from current_attempt)
		),
		preferred_match as (
			select
				case
					when exists (
						select 1
						from user_preferred_topics upt
						where upt.user_id = $1
						  and upt.topic_code = preferred_topic_code((select topic_code from current_attempt))
					)
					then 1
					else 0
				end as preferred_topic_match
		)
		select
			ulp.financial_literacy_level,
			ulp.learning_goal,
			ca.topic_code,
			coalesce(ca.subtopic_code, 'topic_final') as subtopic_code,
			ca.topic_level,
			ca.quiz_type,
			ca.quiz_score,
			l3.avg_last_3_scores,
			pf.previous_fails_same_topic,
			ca.subtopic_order,
			pm.preferred_topic_match,
			1 as completed_interactive
		from current_attempt ca
		join user_learning_profiles ulp
			on ulp.user_id = ca.user_id
		cross join last_3_scores l3
		cross join previous_fails pf
		cross join preferred_match pm
	`

	var features model.ReinforcementFeatures

	err := r.db.QueryRow(ctx, query, userID, attemptID).Scan(
		&features.UserLevel,
		&features.LearningGoal,
		&features.TopicCode,
		&features.SubtopicCode,
		&features.TopicLevel,
		&features.QuizType,
		&features.QuizScore,
		&features.AvgLast3Scores,
		&features.PreviousFailsSameTopic,
		&features.SubtopicOrder,
		&features.PreferredTopicMatch,
		&features.CompletedInteractive,
	)
	if err != nil {
		return nil, err
	}

	return &features, nil
}

func (r *AdaptationRepository) SaveReinforcementPrediction(ctx context.Context, prediction *model.ReinforcementPrediction) error {
	query := `
		insert into user_reinforcement_predictions (
			user_id,
			quiz_id,
			attempt_id,
			quiz_type,
			topic_code,
			subtopic_code,
			score_percent,
			avg_last_3_scores,
			needs_reinforcement,
			prediction,
			probability,
			confidence,
			decision_source,
			model_name,
			model_version
		)
		values (
			$1, $2, $3, $4, $5,
			nullif($6, ''),
			$7, $8, $9, $10,
			$11, $12, $13, $14, $15
		)
		on conflict (attempt_id) do update set
			needs_reinforcement = excluded.needs_reinforcement,
			prediction = excluded.prediction,
			probability = excluded.probability,
			confidence = excluded.confidence,
			decision_source = excluded.decision_source,
			model_name = excluded.model_name,
			model_version = excluded.model_version
	`

	_, err := r.db.Exec(
		ctx,
		query,
		prediction.UserID,
		prediction.QuizID,
		prediction.AttemptID,
		prediction.QuizType,
		prediction.TopicCode,
		prediction.SubtopicCode,
		prediction.ScorePercent,
		prediction.AvgLast3Scores,
		prediction.NeedsReinforcement,
		prediction.Prediction,
		prediction.Probability,
		prediction.Confidence,
		prediction.DecisionSource,
		prediction.ModelName,
		prediction.ModelVersion,
	)

	return err
}

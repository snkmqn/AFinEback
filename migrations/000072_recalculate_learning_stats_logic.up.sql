begin;

with users_with_progress as (
    select distinct user_id
    from user_quiz_progress

    union

    select distinct user_id
    from quiz_attempts
    where status = 'completed'
),
     user_quiz_progress_with_quiz as (
         select
             uqp.user_id,
             uqp.quiz_code,
             uqp.quiz_type,
             coalesce(uqp.topic_code, q.topic_code, t_from_subtopic.code) as topic_code,
             uqp.subtopic_code,
             uqp.best_score_percent,
             uqp.attempts_count,
             uqp.last_attempt_at,
             q.passing_score
         from user_quiz_progress uqp
                  join quizzes q
                       on (
                              uqp.quiz_type = 'subtopic_quiz'
                                  and q.quiz_type = 'subtopic_quiz'
                                  and q.subtopic_code = uqp.quiz_code
                              )
                           or (
                              uqp.quiz_type = 'topic_final_quiz'
                                  and q.quiz_type = 'topic_final_quiz'
                                  and uqp.quiz_code = q.topic_code || '_final'
                              )
                  left join subtopics s
                            on s.code = q.subtopic_code
                  left join topics t_from_subtopic
                            on t_from_subtopic.id = s.topic_id
     ),
     quiz_progress_stats as (
         select
             uwp.user_id,

             coalesce((
                          select count(*)::int
                          from quiz_attempts qa
                          where qa.user_id = uwp.user_id
                            and qa.status = 'completed'
                      ), 0)::int as total_quiz_attempts,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.best_score_percent >= uqpwq.passing_score
                 ), 0)::int as completed_quizzes_count,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.quiz_type = 'subtopic_quiz'
                     and uqpwq.best_score_percent >= uqpwq.passing_score
                 ), 0)::int as completed_subtopic_quizzes_count,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.quiz_type = 'topic_final_quiz'
                     and uqpwq.best_score_percent >= uqpwq.passing_score
                 ), 0)::int as completed_topic_final_quizzes_count,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.quiz_type = 'subtopic_quiz'
                     and uqpwq.best_score_percent >= uqpwq.passing_score
                 ), 0)::int as completed_subtopics_count,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.quiz_type = 'topic_final_quiz'
                     and uqpwq.best_score_percent >= uqpwq.passing_score
                 ), 0)::int as completed_topics_count,

             coalesce(avg(uqpwq.best_score_percent), 0)::numeric(5,2) as average_best_score_percent,

             coalesce(count(uqpwq.*) filter (
                 where uqpwq.best_score_percent = 100
                 ), 0)::int as max_score_quizzes_count,

             max(uqpwq.last_attempt_at) as last_quiz_completed_at

         from users_with_progress uwp
                  left join user_quiz_progress_with_quiz uqpwq
                            on uqpwq.user_id = uwp.user_id
         group by uwp.user_id
     ),
     all_attempts_stats as (
         select
             uwp.user_id,
             coalesce(avg(qa.score_percent), 0)::numeric(5,2) as average_all_attempts_score_percent
         from users_with_progress uwp
                  left join quiz_attempts qa
                            on qa.user_id = uwp.user_id
                                and qa.status = 'completed'
         group by uwp.user_id
     ),
     topic_average_scores as (
         select
             user_id,
             topic_code,
             avg(best_score_percent) as avg_topic_best_score
         from user_quiz_progress_with_quiz
         where topic_code is not null
         group by user_id, topic_code
     ),
     best_topics as (
         select distinct on (user_id)
             user_id,
             topic_code as best_topic_code
         from topic_average_scores
         order by user_id, avg_topic_best_score desc, topic_code
     ),
     weakest_topics as (
         select distinct on (user_id)
             user_id,
             topic_code as weakest_topic_code
         from topic_average_scores
         order by user_id, avg_topic_best_score asc, topic_code
     )
insert into user_learning_stats (
    user_id,
    total_quiz_attempts,
    completed_quizzes_count,
    completed_subtopic_quizzes_count,
    completed_topic_final_quizzes_count,
    completed_subtopics_count,
    completed_topics_count,
    average_best_score_percent,
    average_all_attempts_score_percent,
    max_score_quizzes_count,
    best_topic_code,
    weakest_topic_code,
    last_quiz_completed_at
)
select
    qps.user_id,
    qps.total_quiz_attempts,
    qps.completed_quizzes_count,
    qps.completed_subtopic_quizzes_count,
    qps.completed_topic_final_quizzes_count,
    qps.completed_subtopics_count,
    qps.completed_topics_count,
    qps.average_best_score_percent,
    aas.average_all_attempts_score_percent,
    qps.max_score_quizzes_count,
    bt.best_topic_code,
    wt.weakest_topic_code,
    qps.last_quiz_completed_at
from quiz_progress_stats qps
         join all_attempts_stats aas
              on aas.user_id = qps.user_id
         left join best_topics bt
                   on bt.user_id = qps.user_id
         left join weakest_topics wt
                   on wt.user_id = qps.user_id
on conflict (user_id) do update
    set
        total_quiz_attempts = excluded.total_quiz_attempts,
        completed_quizzes_count = excluded.completed_quizzes_count,
        completed_subtopic_quizzes_count = excluded.completed_subtopic_quizzes_count,
        completed_topic_final_quizzes_count = excluded.completed_topic_final_quizzes_count,
        completed_subtopics_count = excluded.completed_subtopics_count,
        completed_topics_count = excluded.completed_topics_count,
        average_best_score_percent = excluded.average_best_score_percent,
        average_all_attempts_score_percent = excluded.average_all_attempts_score_percent,
        max_score_quizzes_count = excluded.max_score_quizzes_count,
        best_topic_code = excluded.best_topic_code,
        weakest_topic_code = excluded.weakest_topic_code,
        last_quiz_completed_at = excluded.last_quiz_completed_at;

commit;
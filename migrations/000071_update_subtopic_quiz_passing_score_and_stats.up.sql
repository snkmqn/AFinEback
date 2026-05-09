begin;

update quizzes
set passing_score = 70
where quiz_type = 'subtopic_quiz';

update user_learning_stats uls
set completed_subtopics_count = coalesce(stats.completed_subtopics_count, 0)
from (
         select
             user_id,
             count(*) filter (
                 where quiz_type = 'subtopic_quiz'
                     and best_score_percent >= 70
                 )::int as completed_subtopics_count
         from user_quiz_progress
         group by user_id
     ) stats
where uls.user_id = stats.user_id;

update user_learning_stats uls
set completed_subtopics_count = 0
where not exists (
    select 1
    from user_quiz_progress uqp
    where uqp.user_id = uls.user_id
      and uqp.quiz_type = 'subtopic_quiz'
      and uqp.best_score_percent >= 70
);

commit;
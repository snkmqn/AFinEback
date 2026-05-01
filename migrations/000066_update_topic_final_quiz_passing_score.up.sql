begin;

update quizzes
set passing_score = 75
where quiz_type = 'topic_final_quiz';

commit;
begin;

update quizzes
set subtopic_code = 'choose_credit'
where id = 35
  and subtopic_code = 'how_to_choose_credit'
  and quiz_type = 'subtopic_quiz';

update quizzes
set subtopic_code = 'risk_and_return'
where id = 62
  and subtopic_code = 'investments_risk_and_return'
  and quiz_type = 'subtopic_quiz';

update quizzes
set subtopic_code = 'diversification'
where id = 63
  and subtopic_code = 'investments_diversification'
  and quiz_type = 'subtopic_quiz';

update quizzes
set subtopic_code = 'simple_instruments'
where id = 64
  and subtopic_code = 'investments_simple_instruments'
  and quiz_type = 'subtopic_quiz';

update quizzes
set subtopic_code = 'beginner_mistakes'
where id = 65
  and subtopic_code = 'investments_beginner_mistakes'
  and quiz_type = 'subtopic_quiz';

commit;
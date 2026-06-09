create unique index if not exists ux_learning_event_log_attempt_question
    on learning_event_log(attempt_id, question_id)
    where attempt_id is not null and question_id is not null;
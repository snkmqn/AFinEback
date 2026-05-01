begin;

alter table quiz_attempts
    drop constraint if exists quiz_attempts_answers_sum_check;

alter table quiz_attempts
    add constraint quiz_attempts_answers_sum_check
        check (
            status <> 'completed'
                or correct_answers + wrong_answers = total_questions
            );

commit;
begin;

alter table quiz_attempt_answers
    add column if not exists is_selected_option_correct boolean;

alter table quiz_attempt_answers
    add column if not exists is_question_correct boolean;

update quiz_attempt_answers
set is_selected_option_correct = is_correct
where is_selected_option_correct is null;

update quiz_attempt_answers
set is_question_correct = is_correct
where is_question_correct is null;

alter table quiz_attempt_answers
    alter column is_selected_option_correct set not null;

alter table quiz_attempt_answers
    alter column is_question_correct set not null;

alter table quiz_attempt_answers
    drop constraint if exists quiz_attempt_answers_attempt_question_unique;

alter table quiz_attempt_answers
    drop constraint if exists quiz_attempt_answers_attempt_question_option_unique;

alter table quiz_attempt_answers
    add constraint quiz_attempt_answers_attempt_question_option_unique
        unique (attempt_id, question_id, selected_option_id);

create index if not exists idx_quiz_attempt_answers_attempt_id
    on quiz_attempt_answers(attempt_id);

create index if not exists idx_quiz_attempt_answers_question_id
    on quiz_attempt_answers(question_id);

create index if not exists idx_quiz_attempt_answers_selected_option_id
    on quiz_attempt_answers(selected_option_id);

commit;
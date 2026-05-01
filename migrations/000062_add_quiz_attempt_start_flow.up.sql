begin;

alter table quiz_attempts
    add column if not exists status varchar(30) not null default 'completed';

alter table quiz_attempts
    drop constraint if exists quiz_attempts_status_check;

alter table quiz_attempts
    add constraint quiz_attempts_status_check
        check (status in ('in_progress', 'completed', 'expired', 'abandoned'));

alter table quiz_attempts
    add column if not exists started_at timestamptz not null default now();

alter table quiz_attempts
    add column if not exists completed_at timestamptz;

update quiz_attempts
set completed_at = submitted_at
where completed_at is null
  and status = 'completed';

create table if not exists quiz_attempt_questions (
                                                      id bigserial primary key,

                                                      attempt_id bigint not null references quiz_attempts(id) on delete cascade,
                                                      question_id bigint not null references quiz_questions(id) on delete cascade,

                                                      order_index int not null,

                                                      created_at timestamptz not null default now(),

                                                      constraint quiz_attempt_questions_unique
                                                          unique (attempt_id, question_id),

                                                      constraint quiz_attempt_questions_order_unique
                                                          unique (attempt_id, order_index)
);

create index if not exists idx_quiz_attempt_questions_attempt_id
    on quiz_attempt_questions(attempt_id);

create index if not exists idx_quiz_attempt_questions_question_id
    on quiz_attempt_questions(question_id);

commit;
create table if not exists learning_event_log (
                                                  id bigserial primary key,
                                                  user_id bigint not null references users(id) on delete cascade,
                                                  topic_code varchar(100),
                                                  concept_code varchar(100) not null,
                                                  occurred_at timestamptz not null default now(),

                                                  was_correct boolean not null,
                                                  latency_ms integer,
                                                  interval_since_last_seen_seconds integer,

                                                  quiz_id bigint references quizzes(id) on delete set null,
                                                  attempt_id bigint references quiz_attempts(id) on delete cascade,
                                                  question_id bigint references quiz_questions(id) on delete set null,
                                                  source varchar(32) not null default 'quiz'
);

create index if not exists idx_learning_event_log_user_concept_time
    on learning_event_log(user_id, concept_code, occurred_at desc);

create index if not exists idx_learning_event_log_user_topic
    on learning_event_log(user_id, topic_code);

create index if not exists idx_learning_event_log_attempt
    on learning_event_log(attempt_id);
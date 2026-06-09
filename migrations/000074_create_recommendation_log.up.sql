create table if not exists recommendation_log (
id bigserial primary key,
user_id bigint not null references users(id) on delete cascade,
recommended_topic_code varchar(100) not null,
rank_position int not null,
rank_score numeric(8,4) not null,
model_name varchar(100),
model_version varchar(50),
decision_source varchar(50) not null,
was_chosen boolean,
chosen_at timestamptz,
created_at timestamptz not null default now()
);

create index if not exists idx_recommendation_log_user_created_at
on recommendation_log(user_id, created_at desc);

create index if not exists idx_recommendation_log_topic
on recommendation_log(recommended_topic_code);
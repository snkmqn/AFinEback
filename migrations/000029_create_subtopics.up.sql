create table subtopics (
                           id bigserial primary key,
                           topic_id bigint not null references topics(id) on delete cascade,
                           code varchar(100) not null unique,
                           order_index int not null,
                           estimated_minutes int,
                           is_active boolean not null default true,
                           created_at timestamptz not null default now(),
                           updated_at timestamptz not null default now(),
                           constraint subtopics_topic_order_unique
                               unique (topic_id, order_index)
);
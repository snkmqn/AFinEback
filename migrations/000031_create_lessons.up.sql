create table lessons (
                         id bigserial primary key,
                         subtopic_id bigint not null unique references subtopics(id) on delete cascade,
                         is_published boolean not null default true,
                         created_at timestamptz not null default now(),
                         updated_at timestamptz not null default now()
);
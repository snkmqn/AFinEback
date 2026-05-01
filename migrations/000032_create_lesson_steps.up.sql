create table lesson_steps (
                              id bigserial primary key,
                              lesson_id bigint not null references lessons(id) on delete cascade,
                              step_type varchar(50) not null,
                              order_index int not null,
                              interactive_type varchar(50),
                              interactive_content jsonb,
                              created_at timestamptz not null default now(),
                              updated_at timestamptz not null default now(),
                              constraint lesson_steps_order_unique
                                  unique (lesson_id, order_index)
);
create table topics (
                        id bigserial primary key,
                        code varchar(100) not null unique,
                        level varchar(20) not null,
                        order_index int not null,
                        is_active boolean not null default true,
                        created_at timestamptz not null default now(),
                        updated_at timestamptz not null default now(),
                        constraint topics_level_check
                            check (level in ('beginner', 'intermediate', 'advanced')),
                        constraint topics_level_order_unique
                            unique (level, order_index)
);
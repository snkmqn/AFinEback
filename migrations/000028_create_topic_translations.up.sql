create table topic_translations (
                                    id bigserial primary key,
                                    topic_id bigint not null references topics(id) on delete cascade,
                                    language_code varchar(5) not null,
                                    title varchar(255) not null,
                                    description text,
                                    constraint topic_translations_unique
                                        unique (topic_id, language_code)
);
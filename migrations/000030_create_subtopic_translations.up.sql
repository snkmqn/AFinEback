create table subtopic_translations (
                                       id bigserial primary key,
                                       subtopic_id bigint not null references subtopics(id) on delete cascade,
                                       language_code varchar(5) not null,
                                       title varchar(255) not null,
                                       description text,
                                       constraint subtopic_translations_unique
                                           unique (subtopic_id, language_code)
);
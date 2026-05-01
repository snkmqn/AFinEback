create table lesson_step_translations (
                                          id bigserial primary key,
                                          lesson_step_id bigint not null references lesson_steps(id) on delete cascade,
                                          language_code varchar(5) not null,
                                          title varchar(255),
                                          content text,
                                          constraint lesson_step_translations_unique
                                              unique (lesson_step_id, language_code)
);
create index idx_subtopics_topic_id_order_index
    on subtopics(topic_id, order_index);

create index idx_lesson_steps_lesson_id_order_index
    on lesson_steps(lesson_id, order_index);

create index idx_topic_translations_topic_id_language_code
    on topic_translations(topic_id, language_code);

create index idx_subtopic_translations_subtopic_id_language_code
    on subtopic_translations(subtopic_id, language_code);

create index idx_lesson_step_translations_step_id_language_code
    on lesson_step_translations(lesson_step_id, language_code);
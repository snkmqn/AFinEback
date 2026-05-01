create trigger set_topics_updated_at
    before update on topics
    for each row
execute function set_updated_at();

create trigger set_subtopics_updated_at
    before update on subtopics
    for each row
execute function set_updated_at();

create trigger set_lessons_updated_at
    before update on lessons
    for each row
execute function set_updated_at();

create trigger set_lesson_steps_updated_at
    before update on lesson_steps
    for each row
execute function set_updated_at();
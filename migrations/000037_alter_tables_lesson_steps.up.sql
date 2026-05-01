begin;

alter table lesson_step_translations
    add column interactive_content jsonb;

update lesson_step_translations lst
set interactive_content = ls.interactive_content
from lesson_steps ls
where ls.id = lst.lesson_step_id
  and ls.interactive_content is not null;

alter table lesson_steps
    drop column interactive_content;

commit;
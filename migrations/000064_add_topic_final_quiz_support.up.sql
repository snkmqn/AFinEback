begin;

alter table quizzes
    alter column subtopic_code drop not null;

alter table quizzes
    add column if not exists topic_code varchar(100);

alter table quizzes
    drop constraint if exists quizzes_topic_code_fk;

alter table quizzes
    add constraint quizzes_topic_code_fk
        foreign key (topic_code) references topics(code) on delete cascade;

alter table quizzes
    drop constraint if exists quizzes_quiz_target_check;

alter table quizzes
    add constraint quizzes_quiz_target_check
        check (
            (
                quiz_type = 'subtopic_quiz'
                    and subtopic_code is not null
                    and topic_code is null
                )
                or
            (
                quiz_type = 'topic_final_quiz'
                    and topic_code is not null
                    and subtopic_code is null
                )
            );

alter table quizzes
    drop constraint if exists quizzes_subtopic_code_key;

drop index if exists quizzes_unique_subtopic_code;
drop index if exists quizzes_unique_subtopic_quiz;
drop index if exists quizzes_unique_topic_final_quiz;

create unique index quizzes_unique_subtopic_quiz
    on quizzes(subtopic_code)
    where quiz_type = 'subtopic_quiz';

create unique index quizzes_unique_topic_final_quiz
    on quizzes(topic_code)
    where quiz_type = 'topic_final_quiz';

commit;
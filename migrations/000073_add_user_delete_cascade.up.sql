begin;

delete from user_reinforcement_predictions
where user_id not in (
    select id from users
);

delete from user_reinforcement_predictions
where attempt_id not in (
    select id from quiz_attempts
);

delete from user_progress
where user_id not in (
    select id from users
);

delete from user_quiz_progress
where user_id not in (
    select id from users
);

delete from user_learning_stats
where user_id not in (
    select id from users
);

alter table user_progress
    add constraint user_progress_user_id_fk
        foreign key (user_id)
            references users(id)
            on delete cascade;

alter table user_quiz_progress
    add constraint user_quiz_progress_user_id_fk
        foreign key (user_id)
            references users(id)
            on delete cascade;

alter table user_learning_stats
    add constraint user_learning_stats_user_id_fk
        foreign key (user_id)
            references users(id)
            on delete cascade;

alter table user_reinforcement_predictions
    add constraint user_reinforcement_predictions_user_id_fk
        foreign key (user_id)
            references users(id)
            on delete cascade;

alter table user_reinforcement_predictions
    add constraint user_reinforcement_predictions_attempt_id_fk
        foreign key (attempt_id)
            references quiz_attempts(id)
            on delete cascade;

commit;
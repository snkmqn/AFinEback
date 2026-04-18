ALTER TABLE public.user_learning_profiles
    DROP COLUMN current_priority;

ALTER TABLE user_learning_profiles
    ADD COLUMN practical_experience VARCHAR(50),
    ADD COLUMN preferred_language VARCHAR(10),
    ADD COLUMN onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE user_difficult_topics
    RENAME TO user_preferred_topics;

ALTER INDEX user_difficult_topics_user_id_topic_code_idx
    RENAME TO user_preferred_topics_user_id_topic_code_idx;
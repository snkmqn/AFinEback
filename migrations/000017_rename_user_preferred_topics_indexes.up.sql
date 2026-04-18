ALTER INDEX IF EXISTS user_prefered_topics_user_id_topic_code_idx
    RENAME TO user_preferred_topics_user_id_topic_code_idx;

ALTER INDEX IF EXISTS user_prefered_topics_topic_code_idx
    RENAME TO user_preferred_topics_topic_code_idx;
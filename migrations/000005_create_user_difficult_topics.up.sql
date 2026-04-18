CREATE TABLE user_difficult_topics (
                                       id BIGSERIAL PRIMARY KEY,
                                       user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                       topic_code VARCHAR(50) NOT NULL,
                                       created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX user_difficult_topics_user_id_topic_code_idx
    ON user_difficult_topics(user_id, topic_code);

CREATE INDEX user_difficult_topics_topic_code_idx
    ON user_difficult_topics(topic_code);
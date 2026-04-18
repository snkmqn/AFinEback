CREATE TABLE user_practical_experience (
                                           id BIGSERIAL PRIMARY KEY,
                                           user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                           experience_code VARCHAR(50) NOT NULL,
                                           created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX user_practical_experience_user_id_experience_code_idx
    ON user_practical_experience(user_id, experience_code);

CREATE INDEX user_practical_experience_experience_code_idx
    ON user_practical_experience(experience_code);
CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS user_settings (
                                             id BIGSERIAL PRIMARY KEY,
                                             user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,

                                             language_code VARCHAR(10) NOT NULL DEFAULT 'ru',
                                             theme VARCHAR(20) NOT NULL DEFAULT 'system',
                                             notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
                                             reminder_time TIME,

                                             created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                             updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                             CONSTRAINT user_settings_theme_check
                                                 CHECK (theme IN ('light', 'dark', 'system'))
);

CREATE TABLE IF NOT EXISTS user_learning_profiles (
                                                      id BIGSERIAL PRIMARY KEY,
                                                      user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,

                                                      financial_literacy_level VARCHAR(30),
                                                      practical_experience_level VARCHAR(50),
                                                      learning_goal VARCHAR(100),
                                                      current_priority VARCHAR(100),
                                                      time_commitment VARCHAR(50),

                                                      questionnaire_completed BOOLEAN NOT NULL DEFAULT FALSE,
                                                      questionnaire_completed_at TIMESTAMPTZ,

                                                      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                                      updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS user_difficult_topics (
                                                     id BIGSERIAL PRIMARY KEY,
                                                     user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                                     topic_code VARCHAR(50) NOT NULL,

                                                     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                                     CONSTRAINT user_difficult_topics_user_topic_unique
                                                         UNIQUE (user_id, topic_code)
);

CREATE TABLE IF NOT EXISTS user_learning_profile_history (
                                                             id BIGSERIAL PRIMARY KEY,
                                                             user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                                             version INT NOT NULL,

                                                             financial_literacy_level VARCHAR(30),
                                                             practical_experience_level VARCHAR(50),
                                                             learning_goal VARCHAR(100),
                                                             current_priority VARCHAR(100),
                                                             time_commitment VARCHAR(50),

                                                             questionnaire_completed BOOLEAN NOT NULL,
                                                             questionnaire_completed_at TIMESTAMPTZ,

                                                             snapshot_created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                                             CONSTRAINT user_learning_profile_history_user_version_unique
                                                                 UNIQUE (user_id, version)
);

CREATE TABLE IF NOT EXISTS user_difficult_topics_history (
                                                             id BIGSERIAL PRIMARY KEY,
                                                             user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                                             profile_history_id BIGINT NOT NULL REFERENCES user_learning_profile_history(id) ON DELETE CASCADE,
                                                             topic_code VARCHAR(50) NOT NULL,

                                                             created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                                             CONSTRAINT user_difficult_topics_history_unique
                                                                 UNIQUE (profile_history_id, topic_code)
);

CREATE INDEX IF NOT EXISTS idx_user_difficult_topics_user_id
    ON user_difficult_topics(user_id);

CREATE INDEX IF NOT EXISTS idx_user_learning_profile_history_user_id
    ON user_learning_profile_history(user_id);

CREATE INDEX IF NOT EXISTS idx_user_difficult_topics_history_profile_history_id
    ON user_difficult_topics_history(profile_history_id);

DROP TRIGGER IF EXISTS set_user_settings_updated_at ON user_settings;

CREATE TRIGGER set_user_settings_updated_at
    BEFORE UPDATE ON user_settings
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

DROP TRIGGER IF EXISTS set_user_learning_profiles_updated_at ON user_learning_profiles;

CREATE TRIGGER set_user_learning_profiles_updated_at
    BEFORE UPDATE ON user_learning_profiles
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
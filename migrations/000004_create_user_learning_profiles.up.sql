CREATE TABLE user_learning_profiles (
                                        id BIGSERIAL PRIMARY KEY,
                                        user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
                                        financial_literacy_level VARCHAR(30),
                                        learning_goal VARCHAR(100),
                                        current_priority VARCHAR(100),
                                        time_commitment VARCHAR(50),
                                        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                        CONSTRAINT user_learning_profiles_level_check
                                            CHECK (
                                                financial_literacy_level IS NULL OR
                                                financial_literacy_level IN ('beginner', 'basic', 'intermediate', 'advanced')
                                                )
);
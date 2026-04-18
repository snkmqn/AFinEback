ALTER TABLE user_learning_profiles
    DROP CONSTRAINT IF EXISTS user_learning_profiles_level_check,
    DROP CONSTRAINT IF EXISTS user_learning_profiles_practical_experience_check,
    DROP CONSTRAINT IF EXISTS user_learning_profiles_preferred_language_check,
    DROP CONSTRAINT IF EXISTS user_learning_profiles_time_commitment_check;

ALTER TABLE user_learning_profiles
    ADD CONSTRAINT user_learning_profiles_level_check
        CHECK (
            financial_literacy_level IN ('beginner', 'basic', 'intermediate', 'advanced')
            ),

    ADD CONSTRAINT user_learning_profiles_practical_experience_check
        CHECK (
            practical_experience IN ('no_experience', 'tracks_expenses', 'plans_budget', 'manages_finances')
            ),

    ADD CONSTRAINT user_learning_profiles_preferred_language_check
        CHECK (
            preferred_language IN ('ru', 'kk', 'en')
            ),

    ADD CONSTRAINT user_learning_profiles_time_commitment_check
        CHECK (
            time_commitment IN ('5_min', '10_min', '15_min', '20_plus_min')
            );
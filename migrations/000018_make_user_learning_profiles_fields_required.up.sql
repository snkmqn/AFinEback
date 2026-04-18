UPDATE user_learning_profiles
SET financial_literacy_level = 'beginner'
WHERE financial_literacy_level IS NULL;

UPDATE user_learning_profiles
SET practical_experience = 'none'
WHERE practical_experience IS NULL;

UPDATE user_learning_profiles
SET learning_goal = 'general_improvement'
WHERE learning_goal IS NULL;

UPDATE user_learning_profiles
SET preferred_language = 'ru'
WHERE preferred_language IS NULL;

UPDATE user_learning_profiles
SET time_commitment = '10_min'
WHERE time_commitment IS NULL;

UPDATE user_learning_profiles
SET onboarding_completed = FALSE
WHERE onboarding_completed IS NULL;

ALTER TABLE user_learning_profiles
    ALTER COLUMN financial_literacy_level SET NOT NULL,
    ALTER COLUMN practical_experience SET NOT NULL,
    ALTER COLUMN learning_goal SET NOT NULL,
    ALTER COLUMN preferred_language SET NOT NULL,
    ALTER COLUMN time_commitment SET NOT NULL,
    ALTER COLUMN onboarding_completed SET NOT NULL;
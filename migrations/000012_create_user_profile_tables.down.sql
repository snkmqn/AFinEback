DROP TRIGGER IF EXISTS set_user_learning_profiles_updated_at ON user_learning_profiles;
DROP TRIGGER IF EXISTS set_user_settings_updated_at ON user_settings;

DROP TABLE IF EXISTS user_difficult_topics_history;
DROP TABLE IF EXISTS user_learning_profile_history;
DROP TABLE IF EXISTS user_difficult_topics;
DROP TABLE IF EXISTS user_learning_profiles;
DROP TABLE IF EXISTS user_settings;
DROP TABLE IF EXISTS user_practical_experience;


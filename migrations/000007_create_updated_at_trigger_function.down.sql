DROP TRIGGER IF EXISTS set_user_learning_profiles_updated_at ON user_learning_profiles;
DROP TRIGGER IF EXISTS set_user_settings_updated_at ON user_settings;
DROP TRIGGER IF EXISTS set_users_updated_at ON users;

DROP FUNCTION IF EXISTS set_updated_at;
CREATE OR REPLACE FUNCTION set_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER set_user_settings_updated_at
    BEFORE UPDATE ON user_settings
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER set_user_learning_profiles_updated_at
    BEFORE UPDATE ON user_learning_profiles
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
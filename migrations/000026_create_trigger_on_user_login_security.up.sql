CREATE TRIGGER set_user_login_security_updated_at
    BEFORE UPDATE ON user_login_security
    FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
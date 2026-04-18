ALTER TABLE user_settings
    DROP CONSTRAINT IF EXISTS user_settings_language_code_check;

ALTER TABLE user_settings
    ADD CONSTRAINT user_settings_language_code_check
        CHECK (language_code IN ('ru', 'kk', 'en'));
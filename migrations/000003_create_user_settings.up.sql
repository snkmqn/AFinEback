CREATE TABLE user_settings (
                               id BIGSERIAL PRIMARY KEY,
                               user_id BIGINT NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
                               language_code VARCHAR(10) NOT NULL DEFAULT 'ru',
                               theme VARCHAR(20) NOT NULL DEFAULT 'system',
                               notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
                               reminder_time TIME,
                               created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                               updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                               CONSTRAINT user_settings_language_code_check
                                   CHECK (language_code IN ('ru', 'kk', 'en')),

                               CONSTRAINT user_settings_theme_check
                                   CHECK (theme IN ('light', 'dark', 'system'))
);
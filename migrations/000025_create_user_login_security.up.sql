CREATE TABLE user_login_security (
                                     user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
                                     failed_attempts INT NOT NULL DEFAULT 0,
                                     locked_until TIMESTAMPTZ NULL,
                                     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                     CONSTRAINT user_login_security_failed_attempts_check
                                         CHECK (failed_attempts >= 0)
);
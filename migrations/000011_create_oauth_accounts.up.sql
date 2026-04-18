CREATE TABLE oauth_accounts (
                                id BIGSERIAL PRIMARY KEY,
                                user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                provider VARCHAR(32) NOT NULL,
                                provider_user_id VARCHAR(255) NOT NULL,
                                created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

                                CONSTRAINT oauth_accounts_provider_check
                                    CHECK (provider IN ('google')),

                                CONSTRAINT oauth_accounts_provider_user_unique
                                    UNIQUE (provider, provider_user_id),

                                CONSTRAINT oauth_accounts_user_provider_unique
                                    UNIQUE (user_id, provider)
);

CREATE INDEX idx_oauth_accounts_user_id
    ON oauth_accounts(user_id);

CREATE INDEX idx_oauth_accounts_provider_provider_user_id
    ON oauth_accounts(provider, provider_user_id);
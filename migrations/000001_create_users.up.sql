CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       email CITEXT NOT NULL UNIQUE,
                       username VARCHAR(100) NOT NULL,
                       password_hash TEXT NOT NULL,
                       is_active BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
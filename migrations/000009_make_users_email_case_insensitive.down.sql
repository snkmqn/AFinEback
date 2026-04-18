ALTER TABLE users
    DROP CONSTRAINT IF EXISTS users_email_key;

ALTER TABLE users
    ALTER COLUMN email TYPE VARCHAR(255);

ALTER TABLE users
    ADD CONSTRAINT users_email_key UNIQUE (email);

CREATE UNIQUE INDEX IF NOT EXISTS users_email_unique_idx
    ON users(email);
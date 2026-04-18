CREATE EXTENSION IF NOT EXISTS citext;

UPDATE users
SET email = LOWER(email);

ALTER TABLE users
    ALTER COLUMN email TYPE CITEXT;

DROP INDEX IF EXISTS users_email_unique_idx;

ALTER TABLE users
    DROP CONSTRAINT IF EXISTS users_email_key;

ALTER TABLE users
    ADD CONSTRAINT users_email_key UNIQUE (email);
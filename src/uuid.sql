-- tags: extension, uuid4.
-- pgcli: run "\dx" to see all installed extensions.

-- ======================================
-- extensions
-- ======================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;


-- ======================================
-- table declarations
-- ======================================

CREATE TABLE IF NOT EXISTS uuid_users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_name TEXT NOT NULL
);


-- ======================================
-- data inserts
-- ======================================

INSERT INTO uuid_users (user_name)
VALUES ('amiao'), ('yahaha'), ('bili');


-- ======================================
-- queries
-- ======================================

SELECT
    user_id,
    user_name
FROM uuid_users LIMIT 20;

-- list installed extensions.
-- (another way is by using "\dx" in pqcli).
SELECT * FROM pg_extension;
-- list all extensions including uninstalled ones.
SELECT * FROM pg_available_extensions;

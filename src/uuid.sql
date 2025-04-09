-- tags: extension, uuid4.
-- pgcli: run "\dx" to see all installed extensions.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS uuid_users (
    u_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    u_name TEXT NOT NULL
);

INSERT INTO uuid_users (u_name)
VALUES ('amiao'), ('yahaha'), ('bili');

SELECT
    u_id AS id,
    u_name AS name
FROM uuid_users LIMIT 20;

-- list installed extensions. 
-- (another way is by using "\dx" in pqcli).
SELECT * FROM pg_extension;
-- list all extensions including uninstalled ones.
SELECT * FROM pg_available_extensions;

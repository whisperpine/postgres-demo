# error if a .env file doesn't exist.
set dotenv-required

pgcli:
    pgcli ${DATABASE_URL}

# Error if a .env file doesn't exist.
set dotenv-required

# These env vars are implicitly captured by pg_dump and psql:
# PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE.

# list all available subcommands
_default:
  @just --list

# back postgres database
backup:
  # -c: Output commands to clean(drop) database objects prior to writing commands to create them.
  # -C: Begin output with "CREATE DATABASE" command itself and reconnect to created database.
  # -F: Format of the output (value p means plain SQL output and value c means custom archive format suitable for pg_restore).
  pg_dump -c -C -F p \
    -f ${PGDATABASE}.bak \
    -d ${PGDATABASE}

# restore postgres database
restore:
  psql -f ${PGDATABASE}.bak

# lint sql files by sqlfluff
lint PATH="":
  sqlfluff lint {{PATH}}

# fix linting errors found by sqlfluff
fix PATH="":
  sqlfluff fix

# stop and delete the postgres database
down:
  @echo "Are you sure you want to delete the database? [y/n]"
  @read -r response; if [ "$response" != "y" ] && [ "$response" != "Y" ]; then echo "Aborted"; exit 1; fi
  docker compose down -v

# delete the database and relaunch a new one
new:
  @echo "Are you sure you want to delete the database? [y/n]"
  @read -r response; if [ "$response" != "y" ] && [ "$response" != "Y" ]; then echo "Aborted"; exit 1; fi
  docker compose down -v
  docker compose up -d

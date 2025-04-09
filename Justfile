# error if a .env file doesn't exist.
set dotenv-required

# these env vars are implicitly captured by pg_dump and psql:
# PGUSER, PGPASSWORD, PGHOST, PGPORT, PGDATABASE.

# back postgres database
backup:
    # -c: Output commands to clean(drop) database objects prior to writing commands to create them
    # -C: Begin output with “CREATE DATABASE” command itself and reconnect to created database
    # -F: Format of the output (value p means plain SQL output and value c means custom archive format suitable for pg_restore)
    pg_dump -c -C -F p \
        -f ${PGDATABASE}.bak \
        -d ${PGDATABASE}

# restore postgres database
restore:
    psql -f ${PGDATABASE}.bak

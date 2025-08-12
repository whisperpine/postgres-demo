# README

My PostgreSQL playground.

## References

- Official documents: [postgresql.org/docs](https://www.postgresql.org/docs/current/index.html).
- Postgres cheat sheet: [postgres cheat sheet](https://www.timescale.com/learn/postgres-cheat-sheet).
- Postgres ecosystem: [awesome-postgres](https://github.com/dhamaniasad/awesome-postgres).

## Prerequisites

- Docker is up and running.
- `docker compose` command is available.
- [direnv](https://github.com/direnv/direnv) will be used to load env vars in `.env`.
- `psql` is available to connect to postgres server.

## Get Stated

```sh
# create `.env` by the template `.env.example`.
cp .env.example .env 
# load env vars written in `.env`.
direnv allow
# run postgresql as container.
docker compose up -d
# connect to postgres by psql.
psql
```

## Backup and Restore

It's recommended to install [just](https://github.com/casey/just),
so that backup and restore can be simplified as:

```sh
just backup
just restore
```

## Recommendations

- If you are using `nix`, use [nix-direnv](https://github.com/nix-community/nix-direnv)
  to load dev environment automatically.
- CLI with autocompletion and syntax highlighting: [pgcli](https://github.com/dbcli/pgcli)
  (as a alternative to `psql`).
- vim or neovim users may give a try to [vim-dadbod](https://github.com/tpope/vim-dadbod)
  and [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui).

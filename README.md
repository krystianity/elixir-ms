![Elixir-Logo](http://elixir-lang.org/images/logo/logo.png)

# elixir-ms
- elixir microservice base :ant::zap:
- microservice skeleton from scratch aka "You dont need Phoenix"

## Ingredients :star:
- `credo` for linting
- `dialyxir` static analysis
- strong `http server` basis using plug + cowboy
- fast `json` encode/decode using poison
- `http client` using httpoison
- `metrics` using prometheus_ex
- `healthchecks + config` setup using mix tools
- (json) `access log` provided as Plug
- ELK compliant `logger` with simple API
- registry (in-memory cache) with simple API
- `redis client` using redix (pub-sub)
- `JIT Config` via weave
- `RDBMS ORM` via ecto and postgrex
- MIT License

## TODO (coming up)
- (asciify) banner
- uuid v4 generation
- cassandra client to GenServer
- httppoison wrapper similar to request.js
- ecto migrations
- example for tests
- custom dockerfile base on alpine (no deps)

## Requirements
- Erlang/OTP >= 19
- Elixir >= 1.3.0

## Installation
- install Erlang
- install Elixir
- install Mix
- http://elixir-lang.org/install.html#unix-and-unix-like
- `git clone git@github.com:krystianity/elixir-ms.git`
- run `mix deps.get` or `./tools/get-dependencies.sh`
- start via `mix run --no-halt` or `./tools/run.sh`

## Use as docker container via docker-compose
build + run via `docker-compose up --build`

## Testing
run `mix test`

## License
MIT

## Other

### Database Setup
- `docker run -it --rm --link postgres:postgres postgres:9.3 createdb -h postgres -U postgres ex_test`
- `docker run -it --rm --link postgres:postgres postgres:9.3 psql -h postgres -U postgres ex_test`
- `mix ecto.gen.migration add_test_table -r ExTest.Repos.Test`
- `mix ecto.migrate`
- `mix ecto.rollback`
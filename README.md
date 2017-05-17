![Elixir-Logo](http://elixir-lang.org/images/logo/logo.png)

# elixir-ms
- elixir microservice base :ant::zap:
- microservice skeleton from scratch aka "You dont need Phoenix"

[![Build Status](https://travis-ci.org/krystianity/elixir-ms.svg?branch=master)](https://travis-ci.org/krystianity/elixir-ms)

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
- start-up banner
- MIT License

## TODO (coming up)
- uuid v4 generation
- cassandra client to GenServer
- httppoison wrapper similar to request.js
- ecto migrations
- example for tests
- custom dockerfile base on alpine (no deps)

## Requirements
- Erlang/OTP >= 19.3
- Elixir >= 1.4.1

## Installation
- install Erlang
- install Elixir
- install Mix
- http://elixir-lang.org/install.html#unix-and-unix-like
- `git clone git@github.com:krystianity/elixir-ms.git`
- run `mix deps.get` or `./tools/get-dependencies.sh`
- start via `mix start`
- (if you want to run this as is, you need a local postgres (see Other below) and
a redis, otherwise you have to make adjustments to lib/demo.ex and mix.exs)

## Use as docker container via docker-compose
build + run via `docker-compose up --build`

## Testing
run `mix test`

## License
MIT

## Other

### Database Setup
- (requires a local postgres, with a user named "postgres" and a password "postgres"
checkout config/config.exs to change these credentials
- `mix ecto.create`
- `mix ecto.migrate`

### Other Database Stuff
- `mix ecto.gen.migration add_test_table -r ExTest.Repos.Test`
- `mix ecto.rollback`
- `docker run -it --rm --link postgres:postgres postgres:9.3 psql -h postgres -U postgres ex_test`

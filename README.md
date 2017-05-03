# elixir-ms
- elixir microservice base
- building a new microservice skeleton from scratch once again

## comes with
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

## ships a few demos for
- `kafka consumer + producer` using kafka_ex
- `redis pub/sub` using redix_pubsub
- `cassandra client` using xandra

## requirements
- Erlang/OTP >= 19
- Elixir >= 1.3.0

## installation
- git clone this repo
- run `mix deps.get` or `./tools/_get-dependencies.sh`
- start via `./tools/_run.sh`

## build/run in docker container via docker-compose
- (force) build + run via `docker-compose up --build`
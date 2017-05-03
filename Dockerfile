FROM msaraiva/elixir-dev
LABEL authors="Chris Fröhlingsdorf <chris@5cf.de>"

RUN apk update && apk add --no-cache bash

WORKDIR /var/ex-test
ADD . .

RUN erl -version && elixir -v

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get --force && \
    mix clean --force && \
    mix compile --force

CMD ./tools/drun.sh

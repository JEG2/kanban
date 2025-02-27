ARG EX_VSN=1.16.1
ARG OTP_VSN=26.0.2
ARG DEB_VSN=bullseye-20231009-slim
ARG BUILDER_IMG="hexpm/elixir:${EX_VSN}-erlang-${OTP_VSN}-debian-${DEB_VSN}"
ARG RUNNER_IMG="debian:${DEB_VSN}"

FROM ${BUILDER_IMG} AS builder

ENV ERL_FLAGS="+JPperf true"

WORKDIR /app
COPY mix.exs mix.lock ./

ENV MIX_ENV="prod"

RUN apt-get update && apt-get install -y git \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only $MIX_ENV

RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY assets assets
COPY priv priv
RUN mix assets.deploy

COPY lib lib
RUN mix compile

COPY config/runtime.exs config/
COPY rel rel
RUN mix release

FROM ${RUNNER_IMG} AS runner

RUN apt-get update -y \
  && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US:en"
ENV LC_ALL="en_US.UTF-8"

ENV MIX_ENV="prod"

WORKDIR "/app"
RUN chown nobody /app
COPY --from=builder \
  --chown=nobody:root /app/_build/${MIX_ENV}/rel/kanban ./

USER nobody
CMD ["/app/bin/server"]

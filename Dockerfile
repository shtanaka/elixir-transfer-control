FROM elixir:latest

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
 && apt-get install -y postgresql-client inotify-tools nodejs

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force \
    && mix do deps.get, deps.compile \
    && cd apps/tfcon_web/assets && npm install

CMD ["/app/entrypoint.sh"]


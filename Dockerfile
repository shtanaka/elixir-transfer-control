FROM elixir:latest

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get update \
  && apt-get install -y postgresql-client inotify-tools nodejs gcc make libc6

RUN mix do local.hex --force, local.rebar --force, \
  archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

WORKDIR /app
EXPOSE 4000
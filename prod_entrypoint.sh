#!/bin/sh

set -e
mix deps.get

cd apps/tfcon_web/assets && npm install
cd ../../..

while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USERNAME; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "\nPostgres is available: continuing with database setup..."

MIX_ENV=prod mix phx.swagger.generate
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
MIX_ENV=prod mix phx.server
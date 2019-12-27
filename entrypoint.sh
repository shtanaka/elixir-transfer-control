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

mix ecto.create
mix ecto.migrate
mix phx.server
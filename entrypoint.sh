#!/bin/bash
while ! pg_isready -q -h $DB_HOST -p $DB_PORT -U $DB_USERNAME
do
  echo "$(date) - waiting for db"
  sleep 2
done

if [[ -z `psql -Atqc "\\list $DB_NAME"` ]]; then
  echo "Database $DB_NAME does not exist. Creating..."
  mix ecto.create
  mix ecto.migrate
  echo "Database $DB_NAME created."
fi

exec mix phx.server
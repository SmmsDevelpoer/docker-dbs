#!/usr/bin/env sh

# load .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

DB_USERNAME=${1:-example}
DB_PASSWORD=${1:-example}
DB_DATABASE=${1:-example}

docker-compose exec pgsql psql \
  --host="${ENV_PGSQL_HOST}" \
  --port="${ENV_PGSQL_PORT}" \
  --username="${ENV_PGSQL_USERNAME}" \
  --command="CREATE DATABASE ${DB_DATABASE};" \
  --command="CREATE USER ${DB_USERNAME} WITH ENCRYPTED PASSWORD '${DB_PASSWORD}';" \
  --command="GRANT ALL PRIVILEGES ON DATABASE ${DB_DATABASE} TO ${DB_USERNAME};"

docker-compose exec pgsql psql \
  --host="${ENV_PGSQL_HOST}" \
  --port="${ENV_PGSQL_PORT}" \
  --username="${ENV_PGSQL_USERNAME}" \
  --command="\l" \
  --command="\du"

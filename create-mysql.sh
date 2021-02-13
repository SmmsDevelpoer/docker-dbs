#!/usr/bin/env sh

# load .env file
if [ -f .env ]; then
  export $(cat .env | xargs)
fi

DB_USERNAME=${1:-example}
DB_PASSWORD=${1:-example}
DB_DATABASE=${1:-example}

docker-compose exec mysql mysql \
  --host="${ENV_MYSQL_HOST}" \
  --port="${ENV_MYSQL_PORT}" \
  --user="${ENV_MYSQL_USERNAME}" \
  --password="${ENV_MYSQL_PASSWORD}" \
  --execute="CREATE USER '${DB_USERNAME}'@'%' IDENTIFIED BY '${DB_PASSWORD}';" \
  --execute="CREATE DATABASE IF NOT EXISTS ${DB_DATABASE} COLLATE utf8_general_ci;" \
  --execute="GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USERNAME}'@'%';" \
  --execute="FLUSH PRIVILEGES;"

docker-compose exec mysql mysql \
  --host="${ENV_MYSQL_HOST}" \
  --port="${ENV_MYSQL_PORT}" \
  --user="${ENV_MYSQL_USERNAME}" \
  --password="${ENV_MYSQL_PASSWORD}" \
  --execute="SHOW GRANTS FOR ${DB_USERNAME}@'%';" \
  --execute="SHOW DATABASES LIKE '${DB_DATABASE}'"

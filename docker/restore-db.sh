!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER flyway;
	CREATE DATABASE flyway;
	GRANT ALL PRIVILEGES ON DATABASE flyway TO flyway;
	GRANT ALL PRIVILEGES ON DATABASE flyway TO postgres;
EOSQL

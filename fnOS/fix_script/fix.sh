export PGUSER=postgres
psql <<- EOSQL
CREATE USER trim_sac_admin;
CREATE DATABASE "trim_sac" WITH OWNER = "trim_sac_admin";
CREATE USER share;
CREATE DATABASE "trim_sharelink" WITH OWNER = "share";
EOSQL
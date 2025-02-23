CREATE DATABASE lapland;

CREATE USER lapland WITH ENCRYPTED PASSWORD 'lapland';
GRANT ALL PRIVILEGES ON DATABASE lapland TO lapland;

CREATE USER observer WITH ENCRYPTED PASSWORD 'observer';
GRANT CONNECT ON DATABASE lapland TO observer;
GRANT USAGE ON SCHEMA pg_catalog TO observer;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO observer;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA pg_catalog TO observer;
GRANT USAGE ON SCHEMA public TO observer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO observer;
GRANT pg_read_all_stats TO observer;
GRANT pg_monitor TO observer;
GRANT SELECT ON pg_stat_statements TO observer;

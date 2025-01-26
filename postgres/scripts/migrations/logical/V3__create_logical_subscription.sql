CREATE SUBSCRIPTION logical_sub
CONNECTION 'host=postgres_master port=5432 dbname=logical_db user=logical_user password=logical_password'
PUBLICATION logical_pub;

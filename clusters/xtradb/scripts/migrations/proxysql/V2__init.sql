INSERT INTO mysql_servers (hostgroup_id, hostname, port, status) VALUES (1, '10.0.2.10', 3306, 'ONLINE');
INSERT INTO mysql_servers (hostgroup_id, hostname, port, status) VALUES (1, '10.0.2.11', 3306, 'ONLINE');
INSERT INTO mysql_servers (hostgroup_id, hostname, port, status) VALUES (1, '10.0.2.12', 3306, 'ONLINE');

INSERT INTO mysql_users (username, password, default_hostgroup) VALUES ('root','test1234!',1);

SAVE MYSQL SERVERS TO DISK;
SAVE MYSQL USERS TO DISK;

LOAD MYSQL USERS TO RUNTIME;
LOAD MYSQL USERS TO DISK;

UPDATE global_variables SET variable_value='proxysql' WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value='proxysql' WHERE variable_name='mysql-monitor_password';
SELECT * FROM GLOBAL_VARIABLES WHERE variable_name IN ('mysql-monitor_username','mysql-monitor_password');
SELECT * FROM GLOBAL_VARIABLES WHERE variable_name IN ('mysql-monitor_ping_timeout','mysql-monitor_connect_timeout');

LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;

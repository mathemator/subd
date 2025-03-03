CREATE DATABASE IF NOT EXISTS logs;

CREATE TABLE IF NOT EXISTS logs.application_logs
(
    timestamp DateTime DEFAULT now(),
    level String,
    message String,
    logger_name String,
    thread_name String,
    host String,
    ip String
) ENGINE = MergeTree()
ORDER BY timestamp;

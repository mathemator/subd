-- Создание таблицы в новой схеме с той же структурой
CREATE TABLE migrations.flyway_schema_history (
    installed_rank int4 NOT NULL,
    "version" varchar(50) NULL,
    description varchar(200) NOT NULL,
    "type" varchar(20) NOT NULL,
    script varchar(1000) NOT NULL,
    checksum int4 NULL,
    installed_by varchar(100) NOT NULL,
    installed_on timestamp DEFAULT now() NOT NULL,
    execution_time int4 NOT NULL,
    success bool NOT NULL,
    CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank)
) tablespace shop_ts;

-- Индекс
CREATE INDEX flyway_schema_history_s_idx ON migrations.flyway_schema_history USING btree (success) tablespace shop_ts;

INSERT INTO migrations.flyway_schema_history (
    installed_rank, "version", description, "type", script, checksum,
    installed_by, installed_on, execution_time, success
)
SELECT installed_rank, "version", description, "type", script, checksum,
       installed_by, installed_on, execution_time, success
FROM public.flyway_schema_history;
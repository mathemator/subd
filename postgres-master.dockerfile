# docker build -t postgres-master:1.0 -f postgres-master.dockerfile .
FROM postgres:17-bullseye

# Копируем конфигурационные файлы
COPY config/master-postgresql.conf /etc/postgresql/postgresql.conf
COPY config/master-pg_hba.conf /etc/postgresql/pg_hba.conf

RUN chown postgres:postgres /etc/postgresql/*.conf

# Указываем кастомные конфигурации
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf", "-c", "hba_file=/etc/postgresql/pg_hba.conf"]


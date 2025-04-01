FROM postgres:17-bullseye

RUN apt-get update -y\ 
    && apt-get install python3 python3-pip postgresql-17-cron -y\
    && pip3 install --upgrade setuptools\
    && pip3 install psycopg2-binary \
    && pip3 install patroni[zookeeper] \
    && mkdir /data/patroni -p \
    && chown postgres:postgres /data/patroni \
    && chmod 700 /data/patroni 

COPY patroni.yml /etc/patroni.yml
COPY patroni-entrypoint.sh ./entrypoint.sh
USER postgres

ENTRYPOINT ["bin/sh", "/entrypoint.sh"]

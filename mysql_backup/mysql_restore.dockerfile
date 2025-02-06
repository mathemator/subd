# Первый этап: сборка с утилитами
FROM ubuntu:20.04 AS builder

# Установим необходимые утилиты
RUN apt update
RUN apt install -y curl
RUN curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
RUN apt install -y gnupg2 lsb-release ./percona-release_latest.generic_all.deb
RUN percona-release setup pdps-8.0
RUN DEBIAN_FRONTEND=noninteractive apt install -y --fix-missing percona-server-server
RUN apt install -y percona-xtrabackup-80
RUN apt install -y qpress
RUN apt install -y wget
RUN apt install -y nano
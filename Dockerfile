FROM ubuntu:16.04

ARG MYDYALOG_USERNAME
ARG MYDYALOG_PASSWORD

ENV DEBIAN_FRONTEND=noninteractive
ENV APL_VERSION=16.0.31812
ENV MAXWS=256M
ENV DYALOG_URL=https://my.dyalog.com/files/installs/linux_64_${APL_VERSION}_unicode.zip

RUN apt-get update && apt-get install -y    \
        git         \
        wget        \
        unzip

RUN cd /tmp && \
    wget --user="${MYDYALOG_USERNAME}" --password="${MYDYALOG_PASSWORD}" ${DYALOG_URL} && \
    unzip linux_64_${APL_VERSION}_unicode.zip && \
    dpkg -i ./linux_64_${APL_VERSION}*.deb

RUN git clone https://github.com/Dyalog/MiServer.git /MiServer

ADD entry.sh /scripts/

EXPOSE 8080
EXPOSE 4502

CMD /scripts/entry.sh

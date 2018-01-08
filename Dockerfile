FROM ubuntu:16.04

ENV DEBIAN_FRONTEND     noninteractive
ENV APL_VERSION=16.0.31812
ENV MAXWS=256M

RUN apt-get update && apt-get install -y    \
        git         \
        wget        \
        unzip

ADD entry.sh /scripts/

EXPOSE 8080
EXPOSE 4502

CMD /scripts/entry.sh

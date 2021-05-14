FROM debian:buster-slim as installer

ENV DYALOG_RELEASE=18.0
ARG DYALOG_VERSION=${DYALOG_RELEASE}.39712
ARG BUILDTYPE=minimal

ADD https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=18.0/dyalog-unicode_${DYALOG_VERSION}_x86_64.tar.gz /tmp/mdyalog.tar.gz
ADD rmfiles.sh /

RUN mkdir -p /opt/mdyalog && tar xf /tmp/mdyalog.tar.gz -C /opt && /rmfiles.sh



FROM debian:buster-slim

ENV DYALOG_RELEASE=18.0

RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*             && \
    sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen    && \
    locale-gen

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:UTF-8
ENV LC_ALL en_GB.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends libncurses5 && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*

COPY --from=0 /opt /opt

ADD entrypoint /

RUN ln -s /run /usr/bin/dyalog

RUN useradd -s /bin/bash -d /home/dyalog -m dyalog

RUN mkdir /app /storage && \
    chmod 777 /app /storage

LABEL org.label-schema.licence="proprietary / non-commercial"   \   
      org.label-schema.licenceURL="https://www.dyalog.com/uploads/documents/Private_Personal_Educational_Licence.pdf"

EXPOSE 4502

USER dyalog
WORKDIR /home/dyalog
ENTRYPOINT ["/entrypoint"]



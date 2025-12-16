FROM debian:trixie-slim AS installer

ARG DYALOG_RELEASE=20.0
ARG BUILDTYPE=minimal
ARG TARGETPLATFORM

RUN apt-get update && apt-get install -y curl wget unixodbc && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*

## DYALOG INSTALL
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        DEBFILE=`curl -o - -s https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=docker.metafile | grep x86_64 | awk -v v="$DYALOG_RELEASE" '$0~v && /deb/ {print $3}'` ;\
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        DEBFILE=`curl -o - -s https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=docker.metafile | grep aarch64 | awk -v v="$DYALOG_RELEASE" '$0~v && /deb/ {print $3}'` ;\
    fi && \
    curl -o /tmp/dyalog.deb ${DEBFILE}

ADD rmfiles.sh /
RUN dpkg -i --ignore-depends=libtinfo5 /tmp/dyalog.deb && /rmfiles.sh
## END DYALOG INSTALL

## UNIX ODBC FILES
RUN cd /tmp && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        wget https://dev.mysql.com/get/Downloads/Connector-ODBC/9.1/mysql-connector-odbc-9.1.0-linux-glibc2.28-x86-64bit.tar.gz && \
        tar xf mysql-connector-odbc-9.1.0-linux-glibc2.28-x86-64bit.tar.gz && \
        install -d /usr/local/mysql/lib && \
        cp -R mysql-connector-odbc-9.1.0-linux-glibc2.28-x86-64bit/lib/* /usr/local/mysql/lib/ && \
        rm -Rf /tmp/mysql-connector-odbc-9.1.0-linux-glibc2.28-x86-64bit.tar.gz /tmp/mysql-connector-odbc-9.1.0-linux-glibc2.28-x86-64bit ; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        wget https://dev.mysql.com/get/Downloads/Connector-ODBC/9.1/mysql-connector-odbc-9.1.0-linux-glibc2.28-aarch64.tar.gz && \
        tar xf mysql-connector-odbc-9.1.0-linux-glibc2.28-aarch64.tar.gz && \
        install -d /usr/local/mysql/lib && \
        cp -R mysql-connector-odbc-9.1.0-linux-glibc2.28-aarch64/lib/* /usr/local/mysql/lib/ && \
        rm -Rf /tmp/mysql-connector-odbc-9.1.0-linux-glibc2.28-aarch64.tar.gz /tmp/mysql-connector-odbc-9.1.0-linux-glibc2.28-aarch64 ;\
    fi

RUN cd /tmp && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        wget https://dev.mysql.com/get/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.7-linux-ubuntu16.04-x86-64bit.tar.gz   && \
        tar xf mysql-connector-odbc-5.3.7-linux-ubuntu16.04-x86-64bit.tar.gz && \
        install -d /usr/local/mysql/lib && \
        install mysql-connector-odbc-5.3.7-linux-ubuntu16.04-x86-64bit/lib/* /usr/local/mysql/lib/ && \
        rm -Rf /tmp/mysql-connector-odbc-5.3.7-linux-ubuntu16.04-x86-64bit.tar.gz /tmp/mysql-connector-odbc-5.3.7-linux-ubuntu16.04-x86-64bit ;\
    fi

RUN cd /tmp && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        wget https://dlm.mariadb.com/3978179/Connectors/odbc/connector-odbc-3.2.4/mariadb-connector-odbc-3.2.4-debian-bookworm-amd64.tar.gz && \
        tar xf mariadb-connector-odbc-3.2.4-debian-bookworm-amd64.tar.gz && \
        cd mariadb-connector-odbc-3.2.4-debian-bookworm-amd64 && \
        mkdir -p /usr/lib/mariadb/plugin && \
        install lib/mariadb/libmaodbc.so /usr/lib/mariadb && \
        install lib/mariadb/libmariadb.so.3 /usr/lib/mariadb && \
        install lib/mariadb/plugin/* /usr/lib/mariadb/plugin/ && \
        cd /tmp && rm -Rf mariadb-connector-odbc-3.2.4-debian-bookworm-amd64.tar.gz ;\
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        wget https://dlm.mariadb.com/3978144/Connectors/odbc/connector-odbc-3.2.4/mariadb-connector-odbc-3.2.4-debian-bookworm-aarch64.tar.gz && \
        tar xf mariadb-connector-odbc-3.2.4-debian-bookworm-aarch64.tar.gz && \
        cd mariadb-connector-odbc-3.2.4-debian-bookworm-aarch64 && \
        mkdir -p /usr/lib/mariadb/plugin && \
        install lib/mariadb/libmaodbc.so /usr/lib/mariadb && \
        install lib/mariadb/libmariadb.so.3 /usr/lib/mariadb && \
        install lib/mariadb/plugin/* /usr/lib/mariadb/plugin/ && \
        cd /tmp && rm -Rf mariadb-connector-odbc-3.2.4-debian-bookworm-aarch64.tar.gz ;\
    fi
## END UNIXODBC FILES

FROM debian:trixie-slim

ARG TARGETPLATFORM
ENV DYALOG_RELEASE=20.0
ENV ENABLE_CEF=0

RUN apt-get update && apt-get install -y --no-install-recommends locales && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*             && \
    sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen    && \
    locale-gen

ENV LANG=en_GB.UTF-8
ENV LANGUAGE=en_GB:UTF-8
ENV LC_ALL=en_GB.UTF-8

RUN DEBIAN_FRONTEND=noninteractive 	&& \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates     \
    libicu76		\
    netcat-traditional  \ 
    openssl             \
    procps              \
    unixodbc            \ 
    wget             && \
    apt-get clean && rm -Rf /var/lib/apt/lists/*

## DOTNET INSTALL
RUN wget --no-check-certificate -O /tmp/dotnet-install.sh https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh            && \
        cd /tmp && chmod +x dotnet-install.sh                                                                           && \
    if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        ./dotnet-install.sh --runtime dotnet -c 8.0 -i /opt/dotnet                                                      && \
        update-alternatives --install /usr/bin/dotnet dotnet /opt/dotnet/dotnet 8 ;\
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    ## Currently errors with `dotnet_install: Error: `.NET Core Runtime` with version = Unknown failed to install with an error.`
    ## So we are ignoring ALL errors on linux/arm64.
    ## Clearly this is not ideal, However it does seem to install the runtime correctly, but fails to verify it. 
        ./dotnet-install.sh --runtime dotnet -c 8.0 --architecture arm64 -i /opt/dotnet || true                         && \
        update-alternatives --install /usr/bin/dotnet dotnet /opt/dotnet/dotnet 8 ;\
    fi 
## END DOTNET INSTALL


COPY --from=installer /opt/mdyalog /opt/mdyalog

## MySQL
COPY --from=installer /usr/local/mysql/lib /usr/local/mysql/lib

##MariaDB
COPY --from=installer /usr/lib/mariadb /usr/lib/mariadb
RUN ln -s /usr/lib/mariadb/libmariadb.so.3  /lib/libmariadb.so.3

RUN P=$(echo ${DYALOG_RELEASE} | sed 's/\.//g') && update-alternatives --install /usr/bin/dyalog dyalog /opt/mdyalog/${DYALOG_RELEASE}/64/unicode/dyalog ${P}
RUN P=$(echo ${DYALOG_RELEASE} | sed 's/\.//g') && update-alternatives --install /usr/bin/dyalogscript dyalogscript /opt/mdyalog/${DYALOG_RELEASE}/64/unicode/scriptbin/dyalogscript ${P}
RUN cp /opt/mdyalog/${DYALOG_RELEASE}/64/unicode/LICENSE /LICENSE

ADD entrypoint /
ADD odbc.ini /etc/
ADD odbcinst.ini /etc/
RUN chmod 666 /etc/odbc.ini

RUN sed -i "s/{{DYALOG_RELEASE}}/${DYALOG_RELEASE}/" /entrypoint

RUN useradd -s /bin/bash -d /home/dyalog -m dyalog
RUN mkdir /app /storage && \
    chmod 777 /app /storage

LABEL org.label-schema.licence="proprietary / non-commercial"   \   
      org.label-schema.licenceURL="https://www.dyalog.com/uploads/documents/Private_Personal_Educational_Licence.pdf"

EXPOSE 4502

USER dyalog
WORKDIR /home/dyalog
VOLUME [ "/storage", "/app" ]
ENTRYPOINT ["/entrypoint"]



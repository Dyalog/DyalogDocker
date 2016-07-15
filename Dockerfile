FROM ubuntu:14.04

ENV DEBIAN_FRONTEND     noninteractive
ENV APL_VERSION=15.0.27698

RUN apt-get update && apt-get install -y    \
        git         \
        wget        \
        unzip
        
#ADD linux_64_${APL_VERSION}_unicode.x86_64.deb /tmp/

#RUN dpkg -i /tmp/linux_64_${APL_VERSION}_unicode.x86_64.deb

ADD entry.sh /

EXPOSE 8080
EXPOSE 4502

CMD /entry.sh

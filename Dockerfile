FROM ubuntu:14.04

ENV DEBIAN_FRONTEND     noninteractive
ENV APL_VERSION=15.0.29007
ENV MAXWS=256M

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  

RUN apt-get update && apt-get install -y    \
        git         \
        wget        \
        unzip
        
#ADD linux_64_${APL_VERSION}_unicode.x86_64.deb /tmp/

#RUN dpkg -i /tmp/linux_64_${APL_VERSION}_unicode.x86_64.deb

ADD entry.sh /scripts/

EXPOSE 8080
EXPOSE 4502

CMD /scripts/entry.sh

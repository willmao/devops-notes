FROM alpine:3.10

LABEL maintainer="williamsofmao@gmail.com"

# use Alibaba cloud alpine repositories
# remove if your network is fast
RUN echo 'http://mirrors.aliyun.com/alpine/v3.10/main' > /etc/apk/repositories \
    && echo 'http://mirrors.aliyun.com/alpine/v3.10/community' >> /etc/apk/repositories


ENV OPENLDAP_VERSION 2.4.48-r0

RUN apk --no-cache upgrade && \
    apk --no-cache --update add \
    tzdata \
    openldap-overlay-all=$OPENLDAP_VERSION \
    openldap-back-mdb=$OPENLDAP_VERSION \
    openldap=$OPENLDAP_VERSION \
    openldap-clients=$OPENLDAP_VERSION \
    openldap-back-monitor \
    openssl \
    ca-certificates \
    bash \
    net-tools \
    findutils \
    vim \
    wget

RUN wget -qL -O /etc/ssl/certs/EncryptionEverywhereDVTLSCA-G1.crt.pem "https://dl.cacerts.digicert.com/EncryptionEverywhereDVTLSCA-G1.crt.pem" && \
    update-ca-certificates

COPY docker-entrypoint.sh /

WORKDIR /usr/local/openldap

EXPOSE 389 636

ENTRYPOINT [ "/docker-entrypoint.sh" ]

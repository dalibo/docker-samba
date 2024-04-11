FROM alpine:3.19.1
MAINTAINER Dalibo Labs <contact@dalibo.com>
VOLUME /etc/samba
VOLUME /var/lib/samba

RUN apk add --update --no-cache \
        bash \
        ldb-tools \
        gettext-envsubst \
        samba-dc=4.18.9-r0 \
        shadow \
        tini \
        tzdata \
    && samba --version

ADD retry /usr/local/bin/
ADD entrypoint.sh /sbin
ENTRYPOINT ["/sbin/tini", "--", "/sbin/entrypoint.sh", "/usr/sbin/samba", "--foreground", "--debug-stdout"]

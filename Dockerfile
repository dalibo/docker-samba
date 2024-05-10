FROM debian:bookworm
MAINTAINER Dalibo Labs <contact@dalibo.com>
VOLUME /etc/samba
VOLUME /var/lib/samba

RUN set -ex; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends ca-certificates curl; \
    curl -L https://samba.tranquil.it/tissamba-pubkey.gpg > /usr/share/keyrings/tissamba.gpg; \
    echo 'deb [signed-by=/usr/share/keyrings/tissamba.gpg] https://samba.tranquil.it/debian/samba-4.19.6/ bookworm main' > /etc/apt/sources.list.d/samba.list; \
    :

RUN set -ex; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
        python3-markdown \
        samba \
        samba-ad-dc \
        samba-ad-provision \
        samba-vfs-modules \
        tini \
    ; \
    apt-get clean; \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/log/apt \
        /var/log/dpkg.log \
        /var/log/alternatives.log \
    ; \
    samba --version ; \
    samba-tool --version; \
    :

ADD retry /usr/local/bin/
ADD entrypoint.sh /sbin
ENTRYPOINT ["/usr/bin/tini", "-s", "--", "/sbin/entrypoint.sh", "/usr/sbin/samba", "--foreground", "--debug-stdout"]
EXPOSE 53 88 135 139 389 445 464 636

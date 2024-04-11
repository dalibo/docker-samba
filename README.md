# Samba Directory

This image holds a simple samba-dc installation with /docker-entrypoint-init.d.

Upon initialization, entrypoint:

- sources .sh files in bash
- copies .conf file to /etc/samba/smb.conf.d/

Before running samba command, smb.conf is rewritten as include of each files in /etc/samba/smb.conf.d/


## Environment

- `ADMIN_PASS` : the initial `Administrator` password.
- `DOMAIN` : the subdomain for Samba. Default to `ad`.
- `REALM` : the enterprise domain. e.g. `acme.tld`.
- `DNS_BACKEND`. Default to `SAMBA_INTERNAL`. Should be `NONE` for testing.


## Misc details

TLS is enabled by default, but self-signed.
Use `LDAPTLS_REQCERT=allow` ldaputils env var to accept self-signed certificate.

The initial administrator is `CN=Administrator,CN=Users,DC=...`, depending on your realm.

The project have a working `docker-compose.yml` and `entrypoint-init.d` as showcase.
Here is a sample ldapsearch command for realm `samba.docker`:

``` console
$ LDAPTLS_REQCERT=allow ldapsearch -H ldaps://samba.docker -D CN=Administrator,CN=Users,DC=samba,DC=docker -x -w $LDAPPASSWORD -b CN=Users,DC=samba,DC=docker '(objectClass=user)' cn
# extended LDIF
#
# LDAPv3
# base <CN=Users,DC=samba,DC=docker> with scope subtree
# filter: (objectClass=group)
# requesting: cn
#

# Guest, Users, samba.docker
dn: CN=Guest,CN=Users,DC=samba,DC=docker
cn: Guest

...

# search result
search: 2
result: 0 Success

# numResponses: 24
# numEntries: 23
$
```

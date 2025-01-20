```yaml
services:
  openldap_svc:
    hostname: ldap.lab.lan
    # https://hub.docker.com/r/bitnami/openldap
    image: bitnami/openldap:latest
    extra_hosts:
    - dockerhost:host-gateway
    - ldap.lab.lan:192.168.1.6
    container_name: openldap_svc
    restart: unless-stopped
    ports:
    - 389:389
    - 636:636
    environment:
    - LDAP_PORT_NUMBER=389
    - LDAP_ROOT=dc=lab,dc=lan

    # cn=admin,dc=lab,dc=lan
    - LDAP_ADMIN_USERNAME=admin
    - LDAP_ADMIN_PASSWORD=password
    - LDAP_CONFIG_ADMIN_ENABLED=yes
    # cn=config,cn=config
    - LDAP_CONFIG_ADMIN_USERNAME=config
    - LDAP_CONFIG_ADMIN_PASSWORD=password
    - LDAP_USERS=user
    - LDAP_PASSWORDS=password
    #- LDAP_USER_DC=users
    #- LDAP_GROUP=users

    #- LDAP_ADD_SCHEMAS=yes
    #- LDAP_EXTRA_SCHEMAS=cosine,inetorgperson,nis

    # - LDAP_LDAPS_PORT_NUMBER=636
    # - LDAP_ENABLE_TLS=yes
    # - LDAP_LDAPS_PORT_NUMBER=636
    # - LDAP_TLS_CERT_FILE=/opt/bitnami/openldap/certs/openldap.crt
    # - LDAP_TLS_KEY_FILE=/opt/bitnami/openldap/certs/openldap.key
    # - LDAP_TLS_CA_FILE=/opt/bitnami/openldap/certs/openldapCA.crt
    volumes:
    - ./data/openldap:/bitnami/openldap
    - ./data/certs:/opt/bitnami/openldap/certs


  # sudo rm -rf data
  # mkdir -p data/{openldap,certs} ; chmod -R 777 data

  # olcDatabase={0}config - internal config (replaces slapd.conf)
  # olcDatabase={1}hdb - (deprecated) hierarchial database used for user data storage
  # olcDatabase={2}mdb - (modern) memory mapped database used for user data storage
  # olcDatabase={3}bdb - (deprecated) berkeley database for user data storage
  # olcDatabase={4}ldbm - (deprecated) flat-file database for data storage
  # olcDatabase={5}passwd - user passwords
  # olcDatabase={6}group - user groups (posixGroup)
  # olcDatabase={7}dns - domains
  # olcDatabase={8}smtp - mail
  # olcDatabase={9}ldap - external ldap access
  # olcDatabase={10}changelog - directory changelog
  # olcDatabase={11}auditlog - directory audit (for compliance)
  # olcDatabase={1}monitor,cn=config - server monitoring and statistics

  # Database access via olcRootDN/olcRootPW _OR_ olcAccess attribute:
  
  # ```
  # dn: olcDatabase={2}mdb,cn=config
  # changetype: modify
  # add: olcAccess
  # olcAccess: to *
  #   by dn.exact="cn=globaladmin,cn=config" manage
  #   by * none
  # ```

  # ldapsearch -x -b 'dc=lab,dc=lan' -H ldap://192.168.1.6 -D 'cn=admin,dc=lab,dc=lan' -W '(objectClass=*)'

  phpldapadmin2_svc:
    # https://hub.docker.com/r/leenooks/phpldapadmin
    # https://github.com/leenooks/phpLDAPadmin
    image: leenooks/phpldapadmin:2.0.0-dev-x86_64
    container_name: phpldapadmin_svc
    extra_hosts:
    - dockerhost:host-gateway
    - ldap.lab.lan:192.168.1.6
    restart: unless-stopped
    ports:
    - 80:8080
    environment:
    - LDAP_HOST=ldap.lab.lan
    - LDAP_BASE_DN=dc=lab,dc=lan
    - LDAP_USERNAME=cn=admin,dc=lab,dc=lan
    - LDAP_PASSWORD=password
    - LDAP_PORT=389
    - LDAP_TLS=false
    - LDAP_NAME=Lab

  phpldapadmin1_svc:
    image: myphpldapadmin
    container_name: phpldapadmin1_svc
    extra_hosts:
    - dockerhost:host-gateway
    - ldap.lab.lan:192.168.1.6
    restart: unless-stopped
    ports:
    - 80:80
    environment:
    - LDAP_NAME=Lab LDAP
    - LDAP_HOST=ldap.lab.lan
    - LDAP_BASE=dc=lab,dc=lan
    - LDAP_BIND_DN=cn=admin,dc=lab,dc=lan
    - LDAP_BIND_PW=password
    - LDAP_PORT=389
    #- LDAP_TLS=false

```
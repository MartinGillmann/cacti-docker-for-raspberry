# Dockerfile for cacti
# Save this file as Dockerfile and follow the instructions at the end of this file.
# The only configuration you need to alter is MYSERVERNAME a few lines below.
FROM ubuntu:18.04

# Set your ENV variables
ENV MYSERVERNAME=10.41.234.53
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=cacti
ENV MYSQL_USER=cactiuser17
ENV MYSQL_PASSWORD=cactipassword17
ENV MYAPACHENAME=ApForCacti
ENV DEBIAN_FRONTEND=noninteractive

LABEL maintainer="Martin Gillmann <https://github.com/MartinGillmann>"
LABEL description="Cacti (https://cacti.net) easily hosted on a raspberrypi 4 (https://www.raspberrypi.com/products/raspberry-pi-4-model-b/)"
LABEL version="17.0"

# Create needed folders
RUN mkdir /startup/
RUN mkdir /var/www
RUN mkdir /var/www/html
RUN mkdir /var/www/html/cacti
RUN mkdir /etc/cron.d
WORKDIR /startup

#
# Create needed startup files
#
### /startup/startup.sh
RUN cat <<EOF > /startup/startup.sh

bash /startup/startup_mysql.sh
bash /startup/startup_apache2.sh
bash /startup/startup_cacti.sh
service cron start
service --status-all > /startup/startup_done.txt
echo "$(date) Cacti Startup: You are ready to start. Open the browser on http://<MYSERVERNAME>/cacti"
while true; do sleep 3600; done
EOF

### /startup/startup_mysql.sh
RUN base64 -d <<EOF > /startup/startup_mysql.sh
CmVjaG8gIiQoZGF0ZSkgTXlTUUwiCgpzbGVlcCAxMHMKZWNobyAiU3RhcnRpbmcgZGF0YWJhc2Ug
c2V0dXAhIgp1c2VybW9kIC1kIC92YXIvbGliL215c3FsLyBteXNxbAoKcGhwIC9zdGFydHVwL3Nl
ZC5waHAgL2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJfZW5kXyIgIltjbGllbnRdIgpwaHAg
L3N0YXJ0dXAvc2VkLnBocCAvZXRjL215c3FsL2NvbmYuZC9teXNxbC5jbmYgIl9lbmRfIiAiZGVm
YXVsdC1jaGFyYWN0ZXItc2V0PXV0ZjhtYjQiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvbXlz
cWwvY29uZi5kL215c3FsLmNuZiAiX2VuZF8iICJbbXlzcWxdIgpwaHAgL3N0YXJ0dXAvc2VkLnBo
cCAvZXRjL215c3FsL2NvbmYuZC9teXNxbC5jbmYgIl9lbmRfIiAiZGVmYXVsdC1jaGFyYWN0ZXIt
c2V0PXV0ZjhtYjQiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvbXlzcWwvY29uZi5kL215c3Fs
LmNuZiAiX2VuZF8iICJbbXlzcWxkXSIKcGhwIC9zdGFydHVwL3NlZC5waHAgL2V0Yy9teXNxbC9j
b25mLmQvbXlzcWwuY25mICJfZW5kXyIgImNvbGxhdGlvbl9zZXJ2ZXI9dXRmOG1iNF91bmljb2Rl
X2NpIgpwaHAgL3N0YXJ0dXAvc2VkLnBocCAvZXRjL215c3FsL2NvbmYuZC9teXNxbC5jbmYgIl9l
bmRfIiAiY2hhcmFjdGVyX3NldF9zZXJ2ZXI9dXRmOG1iNCIKcGhwIC9zdGFydHVwL3NlZC5waHAg
L2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJfZW5kXyIgIm1heF9oZWFwX3RhYmxlX3NpemU9
MTUwTSIKcGhwIC9zdGFydHVwL3NlZC5waHAgL2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJf
ZW5kXyIgInRtcF90YWJsZV9zaXplPTE1ME0iCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvbXlz
cWwvY29uZi5kL215c3FsLmNuZiAiX2VuZF8iICJpbm5vZGJfYnVmZmVyX3Bvb2xfc2l6ZT0yMDAw
TSIKcGhwIC9zdGFydHVwL3NlZC5waHAgL2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJfZW5k
XyIgImlubm9kYl9mbHVzaF9sb2dfYXRfdHJ4X2NvbW1pdCA9IDMiCnBocCAvc3RhcnR1cC9zZWQu
cGhwIC9ldGMvbXlzcWwvY29uZi5kL215c3FsLmNuZiAiX2VuZF8iICJpbm5vZGJfZmx1c2hfbG9n
X2F0X3RpbWVvdXQgPSAzIgkKcGhwIC9zdGFydHVwL3NlZC5waHAgL2V0Yy9teXNxbC9jb25mLmQv
bXlzcWwuY25mICJfZW5kXyIgImlubm9kYl9yZWFkX2lvX3RocmVhZHMgPSAzMiIKcGhwIC9zdGFy
dHVwL3NlZC5waHAgL2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJfZW5kXyIgImlubm9kYl93
cml0ZV9pb190aHJlYWRzID0gMTYiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvbXlzcWwvY29u
Zi5kL215c3FsLmNuZiAiX2VuZF8iICJpbm5vZGJfYnVmZmVyX3Bvb2xfaW5zdGFuY2VzID0gNCIK
cGhwIC9zdGFydHVwL3NlZC5waHAgL2V0Yy9teXNxbC9jb25mLmQvbXlzcWwuY25mICJfZW5kXyIg
Imlubm9kYl9pb19jYXBhY2l0eSA9IDUwMDAiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvbXlz
cWwvY29uZi5kL215c3FsLmNuZiAiX2VuZF8iICJpbm5vZGJfaW9fY2FwYWNpdHlfbWF4ID0gMTAw
MDAiCgpzZXJ2aWNlIG15c3FsIHN0YXJ0CnNsZWVwIDJzCnNlcnZpY2UgbXlzcWwgc3RhcnQKc2Vy
dmljZSAtLXN0YXR1cy1hbGwgPiAvc3RhcnR1cC9jaGVja19zcWxfc3RhcnRlZC50eHQKbXlzcWwg
LXUgcm9vdCAtcCRNWVNRTF9ST09UX1BBU1NXT1JEIC1lICJDUkVBVEUgREFUQUJBU0UgJE1ZU1FM
X0RBVEFCQVNFIjsKbXlzcWwgLXUgcm9vdCAtcCRNWVNRTF9ST09UX1BBU1NXT1JEICRNWVNRTF9E
QVRBQkFTRSA8IC92YXIvd3d3L2h0bWwvY2FjdGkvY2FjdGkuc3FsCm15c3FsX3R6aW5mb190b19z
cWwgL3Vzci9zaGFyZS96b25laW5mbyB8IG15c3FsIC11IHJvb3QgLXAkTVlTUUxfUk9PVF9QQVNT
V09SRCBteXNxbApteXNxbCAtdSByb290IC1wJE1ZU1FMX1JPT1RfUEFTU1dPUkQgLWUgIkdSQU5U
IEFMTCBQUklWSUxFR0VTIE9OICRNWVNRTF9EQVRBQkFTRS4qIFRPICckTVlTUUxfVVNFUidAJ2xv
Y2FsaG9zdCcgSURFTlRJRklFRCBCWSAnJE1ZU1FMX1BBU1NXT1JEJyI7Cm15c3FsIC11IHJvb3Qg
LXAkTVlTUUxfUk9PVF9QQVNTV09SRCAtZSAiR1JBTlQgU0VMRUNUIE9OIG15c3FsLnRpbWVfem9u
ZSBUTyAnJE1ZU1FMX1VTRVInQCdsb2NhbGhvc3QnIElERU5USUZJRUQgQlkgJyRNWVNRTF9QQVNT
V09SRCciOwpteXNxbCAtdSByb290IC1wJE1ZU1FMX1JPT1RfUEFTU1dPUkQgLWUgIkdSQU5UIFNF
TEVDVCBPTiBteXNxbC50aW1lX3pvbmVfbmFtZSBUTyAnJE1ZU1FMX1VTRVInQCdsb2NhbGhvc3Qn
IElERU5USUZJRUQgQlkgJyRNWVNRTF9QQVNTV09SRCciOwoKc2VydmljZSBteXNxbCByZXN0YXJ0
Cgo=
EOF

### /startup/startup_apache2.sh
RUN base64 -d <<EOF > /startup/startup_apache2.sh
CmVjaG8gIiQoZGF0ZSkgQXBhY2hlMiIKCgojIGVkaXQgL2V0Yy9waHAvNy4yL2FwYWNoZTIvcGhw
LmluaSBhbmQgL2V0Yy9waHAvNy4yL2NsaS9waHAuaW5pIGFjY29yZGluZyB0byBodHRwczovL2dy
ZWVuLmNsb3VkL2RvY3MvaG93LXRvLWluc3RhbGwtYW5kLWNvbmZpZ3VyZS1jYWN0aS1vbi11YnVu
dHUtMjAtMDQvCnNlZCAtaSAnL15Ib3N0bmFtZUxvb2t1cHMvYSBTZXJ2ZXJOYW1lICciJE1ZU0VS
VkVSTkFNRSInJyAvZXRjL2FwYWNoZTIvYXBhY2hlMi5jb25mCnNlZCAtaSAnL15Ib3N0bmFtZUxv
b2t1cHMvYSBIZWFkZXIgYWRkIFgtQ3VzdG9tLUhlYWRlciAiSGVsbG9Xb3JsZCInIC9ldGMvYXBh
Y2hlMi9hcGFjaGUyLmNvbmYKCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvcGhwLzcuMi9jbGkv
cGhwLmluaSAibWVtb3J5X2xpbWl0ID0iICJtZW1vcnlfbGltaXQgPSA0MDBNIgpwaHAgL3N0YXJ0
dXAvc2VkLnBocCAvZXRjL3BocC83LjIvY2xpL3BocC5pbmkgIm1heF9leGVjdXRpb25fdGltZSA9
IiAibWF4X2V4ZWN1dGlvbl90aW1lID0gNjAiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMvcGhw
LzcuMi9jbGkvcGhwLmluaSAiO2RhdGUudGltZXpvbmUgPSIgImRhdGUudGltZXpvbmUgPSAnRXVy
b3BlL1p1cmljaCciCgpwaHAgL3N0YXJ0dXAvc2VkLnBocCAvZXRjL3BocC83LjIvYXBhY2hlMi9w
aHAuaW5pICJtZW1vcnlfbGltaXQgPSIgIm1lbW9yeV9saW1pdCA9IDQwME0iCnBocCAvc3RhcnR1
cC9zZWQucGhwIC9ldGMvcGhwLzcuMi9hcGFjaGUyL3BocC5pbmkgIm1heF9leGVjdXRpb25fdGlt
ZSA9IiAibWF4X2V4ZWN1dGlvbl90aW1lID0gNjAiCnBocCAvc3RhcnR1cC9zZWQucGhwIC9ldGMv
cGhwLzcuMi9hcGFjaGUyL3BocC5pbmkgIjtkYXRlLnRpbWV6b25lID0iICJkYXRlLnRpbWV6b25l
ID0gJ0V1cm9wZS9adXJpY2gnIgoKCmEyZW5tb2QgcmV3cml0ZQphMmVubW9kIGhlYWRlcnMKc2Vy
dmljZSBhcGFjaGUyIHJlc3RhcnQKc2VydmljZSAtLXN0YXR1cy1hbGwgPiAvc3RhcnR1cC9jaGVj
a19hcGFjaGUyX3N0YXJ0ZWQudHh0Cgo=
EOF

### /startup/startup_cacti.sh
RUN base64 -d <<EOF > /startup/startup_cacti.sh
ZWNobyAiJChkYXRlKSBDYWN0aSIKY2F0IC92YXIvd3d3L2h0bWwvY2FjdGkvaW5jbHVkZS9jYWN0
aV92ZXJzaW9uCgojY3AgL3Zhci93d3cvaHRtbC9jYWN0aS9pbmNsdWRlL2NvbmZpZy5waHAuZGlz
dCAvdmFyL3d3dy9odG1sL2NhY3RpL2luY2x1ZGUvY29uZmlnLnBocApwaHAgL3N0YXJ0dXAvc2Vk
LnBocCAvdmFyL3d3dy9odG1sL2NhY3RpL2luY2x1ZGUvY29uZmlnLnBocCAiXCRkYXRhYmFzZV9w
YXNzd29yZCA9ICIgIlwkZGF0YWJhc2VfcGFzc3dvcmQgPSAnJE1ZU1FMX1BBU1NXT1JEJzsiCnBo
cCAvc3RhcnR1cC9zZWQucGhwIC92YXIvd3d3L2h0bWwvY2FjdGkvaW5jbHVkZS9jb25maWcucGhw
ICJcJGRhdGFiYXNlX3VzZXJuYW1lID0gIiAiXCRkYXRhYmFzZV91c2VybmFtZSA9ICckTVlTUUxf
VVNFUic7IgoKZWNobyAiJChkYXRlKSBDYWN0aTogQ29uZmlnIG9rISIKCmdyZXAgImRhdGFiYXNl
XyIgL3Zhci93d3cvaHRtbC9jYWN0aS9pbmNsdWRlL2NvbmZpZy5waHAgPiAvc3RhcnR1cC9jYWN0
aV9zdGF0ZS50eHQKZWNobyAiJChkYXRlKSBDYWN0aTogU3RhdGUgVHh0IG9rISIKCnRvdWNoIC92
YXIvd3d3L2h0bWwvY2FjdGkvbG9nL2NhY3RpLmxvZwplY2hvICIkKGRhdGUpIENhY3RpOiB0b3Vj
aCBkb25lISIKCmNob3duIC1SIHd3dy1kYXRhOnd3dy1kYXRhIC92YXIvd3d3L2h0bWwvY2FjdGkv
CmVjaG8gIiQoZGF0ZSkgQ2FjdGk6IGNob3duIGRvbmUhIgoKCg==
EOF

### /startup/sed.php
RUN base64 -d <<EOF > /startup/sed.php
PD9waHANCiAgICAgICAgLy8gc2VkLnBocA0KICAgICAgICAvLyBBY2Nlc3MgY29tbWFuZC1saW5l
IGFyZ3VtZW50cw0KICAgICAgICAkYXJnRmlsZSA9ICRhcmd2WzFdOw0KICAgICAgICAkYXJnTGlu
ZU9sZCA9ICRhcmd2WzJdOw0KICAgICAgICAkYXJnTGluZU5ldyA9ICRhcmd2WzNdOw0KLy8gICAg
ICBlY2hvICJBcmdGaWxlOiAkYXJnRmlsZVxuIjsNCi8vICAgICAgZWNobyAiQXJnTGluZU9sZDog
JGFyZ0xpbmVPbGRcbiI7DQovLyAgICAgIGVjaG8gIkFyZ0xpbmVOZXc6ICRhcmdMaW5lTmV3XG4i
Ow0KDQogICAgICAgIC8vIFJlYWQgdGhlIGNvbnRlbnRzIG9mIHRoZSBmaWxlIGludG8gYW4gYXJy
YXkNCiAgICAgICAgJGZpbGVMaW5lcyA9IGZpbGUoJGFyZ0ZpbGUpOw0KICAgICAgICAkb3V0VGV4
dCA9ICIiOw0KICAgICAgICAkbGVmdCA9IDA7DQogICAgICAgICRjaGFuZ2VkID0gMDsNCg0KICAg
ICAgICBpZiAoJGFyZ0xpbmVPbGQgPT09ICJfZW5kXyIpIHsNCiAgICAgICAgICAgICAgICBmb3Jl
YWNoICgkZmlsZUxpbmVzIGFzICYkbGluZSkgew0KICAgICAgICAgICAgICAgICAgICAgICAgJG91
dFRleHQgPSAkb3V0VGV4dCAuICRsaW5lOw0KICAgICAgICAgICAgICAgIH0NCi8vICAgICAgICAg
ICAgICBlY2hvICI9PiBhZGRpbmcgYXQgZW5kXG4iOw0KICAgICAgICAgICAgICAgICRvdXRUZXh0
ID0gJG91dFRleHQgLiAkYXJnTGluZU5ldyAuICJcbiI7DQogICAgICAgICAgICAgICAgJGNoYW5n
ZWQrKzsNCiAgICAgICAgfQ0KICAgICAgICBlbHNlIHsNCiAgICAgICAgICAgICAgICBmb3JlYWNo
ICgkZmlsZUxpbmVzIGFzICYkbGluZSkgew0KICAgICAgICAgICAgICAgICAgICAgICAgaWYgKHN0
cmxlbigkbGluZSkgPCBzdHJsZW4oJGFyZ0xpbmVPbGQpKSB7DQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICRvdXRUZXh0ID0gJG91dFRleHQgLiAkbGluZTsNCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgJGxlZnQrKzsNCiAgICAgICAgICAgICAgICAgICAgICAgIH0NCiAg
ICAgICAgICAgICAgICAgICAgICAgIGVsc2UgaWYgKHN1YnN0cigkbGluZSwgMCwgc3RybGVuKCRh
cmdMaW5lT2xkKSkgPT09ICRhcmdMaW5lT2xkKSB7DQovLyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGVjaG8gIj0+IG92ZXJyaWRpbmc6ICIgLiAkbGluZSAuICJcbiI7DQogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICRvdXRUZXh0ID0gJG91dFRleHQgLiAkYXJnTGluZU5ldyAu
ICJcbiI7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICRjaGFuZ2VkKys7DQogICAg
ICAgICAgICAgICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAkb3V0VGV4dCA9ICRvdXRUZXh0IC4gJGxpbmU7DQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICRsZWZ0Kys7DQogICAgICAgICAgICAgICAgICAgICAgICB9DQogICAgICAgICAg
ICAgICAgfQ0KICAgICAgICB9DQoNCiAgICAgICAgLy8gV3JpdGUgdGhlIG1vZGlmaWVkIGNvbnRl
bnQgYmFjayB0byB0aGUgZmlsZQ0KICAgICAgICBmaWxlX3B1dF9jb250ZW50cygkYXJnRmlsZSwg
JG91dFRleHQpOw0KDQogICAgICAgIGVjaG8gIlNFRDogJGNoYW5nZWQvJGxlZnQgb24gIiAuICRh
cmdMaW5lTmV3IC4gIlxuIjsNCj8+DQoNCg0K
EOF

### /etc/cron.d/cacti
RUN cat <<EOF > /etc/cron.d/cacti
*/5 * * * * root /usr/bin/php -q /var/www/html/cacti/poller.php > /var/log/cacti_poller.log
EOF


# Install required packages (adjust versions as needed)
RUN apt-get update
# Essentials
RUN apt-get install -y curl telnet iputils-ping snmp vim cron wget
# mySql
RUN apt-get install -y rrdtool mysql-client mysql-server graphviz
# apache2
RUN apt-get install -y apache2 php php-mysql libapache2-mod-php php-xml php-ldap php-mbstring php-gd php-gmp php-intl php-snmp librrds-perl
# apt-get cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

### cacti-latest.tar.gz
RUN wget http://files.cacti.net/cacti/linux/cacti-latest.tar.gz


# Finish off needed files
RUN tar xz -f /startup/cacti-latest.tar.gz -C /var/www/html/cacti --strip-components=1
RUN rm /startup/cacti-latest.tar.gz
RUN chmod +x /startup/startup.sh
RUN chmod +x /startup/startup_mysql.sh
RUN chmod +x /startup/startup_apache2.sh
RUN chmod +x /startup/startup_cacti.sh

EXPOSE 80

# At the very end, run forever ...
ENTRYPOINT ["bash", "-c", "/startup/startup.sh"]

#############################################################################3
#
#       sudo docker build -t i_cacti_v17 -f Dockerfile .
#       sudo docker run -d --restart=unless-stopped -t --name c_cacti_v17 -p 8081:80  --hostname CactiV17 i_cacti_v17
#
#       * List / Analyse
#       sudo docker image ls -a
#       sudo docker container ls -a
#       sudo docker logs c_cacti_v17
#       sudo ss -tulnp | grep docker
#	      sudo docker logs c_cacti_v17
#
#
#
#       * Step into
#       sudo docker exec -it  c_cacti_v17 /bin/sh
#
#       *** Remove
#       sudo docker rm -f c_cacti_v17 && sudo docker rmi -f i_cacti_v17
#       rm -rf *
#
#       *** Jump
#       cd /home/pi/Docker/Cacti
#
#		''' new Cycle
#17		sudo docker rm -f c_cacti_v17 && sudo docker rmi -f i_cacti_v17 && sudo docker build -t i_cacti_v17 -f Dockerfile . && sudo docker run -d --restart=unless-stopped -t --name c_cacti_v17 -p 8081:80  --hostname CactiV17 i_cacti_v17 && sudo docker logs -f c_cacti_v17
#
# 		http://10.41.11.54:8081/cacti/
# 		admin admin
################################################################################

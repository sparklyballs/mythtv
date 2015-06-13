FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose port
EXPOSE 3306 3389

# Add local files
ADD src/ /root/

# volumes
VOLUME /db

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# mv startup file(s) and make executable
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/002-bring-up-rdp.sh /etc/my_init.d/002-bring-up-rdp.sh && \
mv /root/003-bring-up-database.sh /etc/my_init.d/003-bring-up-database.sh && \
chmod +x /etc/my_init.d/* && \

# add repos
echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
apt-add-repository ppa:ubuntu-mate-dev/ppa && \
apt-add-repository ppa:ubuntu-mate-dev/trusty-mate && \

# install supervisor
apt-get update -qq && \
apt-get install supervisor -y && \ 

# install mythtv 
apt-get install \
mythtv-backend -y && \

# set a password for root and add to group mythtv
usermod -a -G mythtv root && \
echo "root:root" | chpasswd && \

# install misc dependencies and mate desktop
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
apt-get update -qq && \
apt-get install  --force-yes --no-install-recommends \
wget \
openjdk-7-jre \
sudo \
mate-desktop-environment-core \
x11vnc \
xvfb \
gtk2-engines-murrine \
ttf-ubuntu-font-family -qy && \

# install xrdp
apt-get install \
xrdp -y && \
mv /root/xrdp.ini /etc/xrdp/xrdp.ini && \

# install mariadb
apt-get install \
mariadb-server -y && \


# Tweak my.cnf
sed -i -e 's#\(bind-address.*=\).*#\1 0.0.0.0#g' /etc/mysql/my.cnf && \
sed -i -e 's#\(log_error.*=\).*#\1 /db/mysql_safe.log#g' /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 nobody/g' /etc/mysql/my.cnf && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose port
EXPOSE 3306 3389

# Add local files
ADD src/ /root/

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# mv startup file(s) and make executable
mv /root/001-fix-the-time.sh /etc/my_init.d/001-fix-the-time.sh && \
mv /root/002-bring-up-rdp.sh /etc/my_init.d/002-bring-up-rdp.sh && \
chmod +x /etc/my_init.d/* && \

# add repos
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 13551B881504888C && \
echo "deb http://ppa.launchpad.net/mythbuntu/0.27/ubuntu trusty main" >> /etc/apt/sources.list && \
echo "deb-src http://ppa.launchpad.net/mythbuntu/0.27/ubuntu trusty main" >> /etc/apt/sources.list && \
apt-add-repository ppa:ubuntu-mate-dev/ppa && \
apt-add-repository ppa:ubuntu-mate-dev/trusty-mate && \

# install supervisor
apt-get update -qq && \
apt-get install supervisor -y && \ 

# install mythtv 
apt-get install \
mythtv-backend \
mythtv-database -y && \

# install misc dependencies and mate desktop
mv /root/excludes /etc/dpkg/dpkg.cfg.d/excludes && \
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

# create ubuntu user
useradd --create-home --shell /bin/bash --user-group --groups adm,sudo,mythtv,video,audio,cdrom,dialout  ubuntu && \
echo "ubuntu:PASSWD" | chpasswd && \

# set user ubuntu to same uid and guid as nobody:users in unraid
usermod -u 99 ubuntu && \
usermod -g 100 ubuntu && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

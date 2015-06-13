FROM phusion/baseimage:0.9.16

# Set correct environment variables
ENV DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Expose port
# EXPOSE 3306 3389

# Add local files
# ADD src/ /root/

# volumes
VOLUME /db

# Set the locale
RUN locale-gen en_US.UTF-8 && \

# Fix a Debianism of the nobody's uid being 65534
usermod -u 99 nobody && \
usermod -g 100 nobody && \

# update apt
add-apt-repository ppa:kirillshkrogalev/ffmpeg-next && \
echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list && \
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \
echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list && \


# install build dependencies
apt-get update -qqy && \
apt-get install \
git \
build-essential \
yasm \
make \
gcc \
g++ \
ffmpeg \
lame \
libmp3lame0 \
qt4-dev-tools \
uuid-dev \
libfreetype6-dev \
libmp3lame-dev \
libxinerama-dev \
libtag1-dev \
libexiv2-dev \
libdbd-mysql-perl \
libnet-upnp-perl \
libdbi-perl \
python-urlgrabber \
python-mysqldb \
libqt4-sql-mysql \
libtool \
dh-autoreconf \
libvpx-dev \
libx264-dev \
libxvidcore-dev \
python-lxml \
libxml++2.6-dev \
libass-dev \
cpanminus \
libavahi-compat-libdnssd-dev \
libssl-dev \
libsdl1.2-dev \
libfaac-dev \
libfftw3-dev \
libjack-dev -y && \

# install cpan packages
cpanm HTTP::Request LWP::UserAgent IO::Socket::INET6 && \

# fetch source from git
cd /tmp && \
git clone -b fixes/0.27 git://github.com/MythTV/mythtv.git && \
cd mythtv/mythtv && \

# configure and compile mythtv
./configure \
--enable-nonfree \
--enable-libmp3lame \
--enable-libx264 \
--enable-libvpx \
--enable-libxvid \
--enable-sdl \
--enable-libass \
--enable-libfaac \
--enable-libxml2 && \

# make and install mythtv
make && \
make install && \

# clean build dependencies
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
git \
build-essential \
yasm \
make \
gcc \
g++ && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

#!/bin/bash
set -Eeuo pipefail
set -x

yum -y install epel-release

yum -y install git python3 autoconf automake \
	libmpc-devel mpfr-devel gmp-devel bzip2-devel gtk3-devel gnutls-devel curl-devel SDL2-devel\
       	gawk bison flex texinfo patchutils gcc gcc-c++ zlib-devel expat-devel bzip2 \
	wget unzip fuse-libs file

mkdir -p /usr/local/bin

pushd /tmp

pip3 install --user --upgrade sphinx

wget -cO "ninja.zip" "https://github.com/ninja-build/ninja/releases/download/v1.10.1/ninja-linux.zip"
unzip ninja.zip
mv ninja /usr/local/bin
chmod a+x /usr/local/bin/ninja

wget -cO "linuxdeployqt" "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
mv linuxdeployqt /usr/local/bin
chmod a+x /usr/local/bin/linuxdeployqt

popd

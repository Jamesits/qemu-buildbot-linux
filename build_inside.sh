#!/bin/bash
set -Eeuo pipefail
set -x

export DEBIAN_FRONTEND="noninteractive"

DEFAULT_TARGET_LIST="aarch64-softmmu,alpha-softmmu,arm-softmmu,cris-softmmu,hppa-softmmu,i386-softmmu,lm32-softmmu,m68k-softmmu,microblaze-softmmu,microblazeel-softmmu,mips-softmmu,mips64-softmmu,mips64el-softmmu,mipsel-softmmu,moxie-softmmu,nios2-softmmu,or1k-softmmu,ppc-softmmu,ppc64-softmmu,riscv32-softmmu,riscv64-softmmu,rx-softmmu,s390x-softmmu,sh4-softmmu,sh4eb-softmmu,sparc-softmmu,sparc64-softmmu,tricore-softmmu,unicore32-softmmu,x86_64-softmmu,xtensa-softmmu,xtensaeb-softmmu"
DEFAULT_TRACE_BACKENDS="log" # "log,simple"

SOURCE_BASE_DIR="${SOURCE_BASE_DIR:-${HOME}}"
SOURCE_GIT_URL="${SOURCE_GIT_URL:-https://github.com/qemu/qemu}"
SOURCE_GIT_REF="${SOURCE_GIT_REF:-master}"
BUILD_ARTIFACTS_DIR="${BUILD_ARTIFACTS_DIR:-/tmp/qemu-build}"
APPDIR="${APPDIR:-/tmp/appdir}"
DATE=$(date +%Y%m%d)
TARGET_LIST="${TARGET_LIST:-${DEFAULT_TARGET_LIST}}"
TRACE_BACKENDS="${TRACE_BACKENDS:-${DEFAULT_TRACE_BACKENDS}}"
MAKE_FLAGS="${MAKE_FLAGS:--j}" # note that -j might cause OOM (on a 32-core 128G server!)

# ==========================================================================================

# prepare sources
mkdir -p "${SOURCE_BASE_DIR}"
pushd "${SOURCE_BASE_DIR}"

if [ -d "./qemu/.git" ]; then
    echo "INFO: qemu source exists, not cloning again"
    pushd qemu
#    git pull
    popd
else
    rm -rf ./qemu
    git clone "${SOURCE_GIT_URL}" qemu # the configure script will init the submodules, no need to do recursive here
fi

pushd qemu
git reset --hard
git checkout "${SOURCE_GIT_REF}"

# build
rm -rf -- "${BUILD_ARTIFACTS_DIR}"/*
mkdir -p "${BUILD_ARTIFACTS_DIR}"
pushd "${BUILD_ARTIFACTS_DIR}"

${SOURCE_BASE_DIR}/qemu/configure --prefix=/usr \
    --disable-werror --enable-trace-backends="${TRACE_BACKENDS}" --enable-debug \
    --enable-gnutls --enable-nettle --enable-curl --enable-vnc \
    --enable-bzip2 --enable-guest-agent --enable-docs \
    --enable-gtk --enable-sdl --enable-hax \
    --target-list="${TARGET_LIST}"

make all ${MAKE_FLAGS} V=1 CFLAGS="-Wno-redundant-decls"

# make appdir
make install DESTDIR="${APPDIR}"

# end build
popd

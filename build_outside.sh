#!/bin/bash
set -Eeuo pipefail
set -x

DOCKER_BASE_IMAGE="centos:7"
DOCKER_CONTAINER_NAME="qemu_builder_$(date +%s%3N)"

modprobe fuse

docker pull "${DOCKER_BASE_IMAGE}"
docker run -d --rm --name "${DOCKER_CONTAINER_NAME}" \
	-v "$(pwd):/mnt/scripts:Z" \
	--device /dev/fuse \
	--cap-add SYS_ADMIN \
	--security-opt apparmor:unconfined \
	"${DOCKER_BASE_IMAGE}" tail -f /dev/null 

docker exec "${DOCKER_CONTAINER_NAME}" /mnt/scripts/install_deps_inside_centos.sh
docker exec "${DOCKER_CONTAINER_NAME}" /mnt/scripts/build_inside.sh

# docker stop "${DOCKER_CONTAINER_NAME}"

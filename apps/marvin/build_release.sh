#!/bin/bash
set -e

docker build -f Dockerfile.releaser -t marvin:releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

docker run --name marvin_releaser_${DOCKER_UUID} marvin:releaser /bin/true
docker cp marvin_releaser_${DOCKER_UUID}:/opt/marvin.tar.gz tmp/
docker rm marvin_releaser_${DOCKER_UUID}

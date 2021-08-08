#!/bin/bash
set -e

mkdir -p tmp/

docker build -f Dockerfile.releaser -t wa7vc:releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

docker run --name wa7vc_releaser_${DOCKER_UUID} wa7vc:releaser /bin/true
docker cp wa7vc_releaser_${DOCKER_UUID}:/opt/wa7vc.tar.gz tmp/
docker rm wa7vc_releaser_${DOCKER_UUID}

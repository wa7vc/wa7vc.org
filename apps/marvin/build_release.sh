#!/bin/bash
set -e

docker build -f Dockerfile -t marvin_releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
mkdir -p _tmp/

# Create a non-running container to copy the build artifacts from,
# then copy them to the host, then remove the container.
# The final tarball will be created in the _tmp/ directory, and is
# ready to be uploaded to the application server and unpacked.
docker create --name marvin_releaser_${DOCKER_UUID} marvin_releaser
docker cp marvin_releaser_${DOCKER_UUID}:/app _tmp/_build_${DOCKER_UUID}/
docker rm marvin_releaser_${DOCKER_UUID}
tar czf _tmp/marvin.tar.gz -C _tmp/_build_${DOCKER_UUID}/ .
rm -rf _tmp/_build_${DOCKER_UUID}

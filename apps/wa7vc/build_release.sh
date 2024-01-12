#!/bin/bash
set -e

docker build -f Dockerfile -t wa7vc_releaser .

DOCKER_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
mkdir -p _tmp/_build_${DOCKER_UUID}/

# Create a non-running container to copy the build artifacts from,
# then copy them to the host, then remove the container.
# The final tarball will be created in the _tmp/ directory, and is
# ready to be uploaded to the application server and unpacked.
docker create --name wa7vc_releaser_${DOCKER_UUID} wa7vc_releaser
docker cp wa7vc_releaser_${DOCKER_UUID}:/app/. _tmp/_build_${DOCKER_UUID}/
docker rm wa7vc_releaser_${DOCKER_UUID}
tar czf _tmp/wa7vc.tar.gz -C _tmp/_build_${DOCKER_UUID}/ .
rm -rf _tmp/_build_${DOCKER_UUID}

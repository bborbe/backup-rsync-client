#!/bin/sh

set -e

make checkout
#latestTag=$(cd sources;git describe --tags `git rev-list --tags --max-count=1`)
latestTag=$(cd sources;git tag -l --points-at HEAD)

VERSION=latest make build
VERSION=latest make upload
VERSION=latest make clean

if ! test -z "$latestTag"; then
	VERSION=${latestTag} make build
	VERSION=${latestTag} make upload
	VERSION=${latestTag} make clean
fi

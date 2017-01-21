#!/bin/sh

set -e

make checkout
tag=$(cd sources;git tag -l --points-at HEAD)

VERSION=latest make build
VERSION=latest make upload
VERSION=latest make clean

if ! test -z "$tag"; then
	VERSION=${tag} make build
	VERSION=${tag} make upload
	VERSION=${tag} make clean
fi

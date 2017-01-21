#!/bin/sh

set -e

make checkout

latestTag=$(cd sources;git describe --tags `git rev-list --tags --max-count=1`)

VERSION=${latestTag} make build
VERSION=${latestTag} make upload

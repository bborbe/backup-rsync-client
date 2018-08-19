REGISTRY ?= docker.io
VENDOR_VERSION ?= master
ifeq ($(BUILD_VERSION),)
	BUILD_VERSION := $(shell git describe --tags `git rev-list --tags --max-count=1`)
endif
VERSION := $(VENDOR_VERSION)-$(BUILD_VERSION)

default: build upload clean

clean:
	docker rmi $(REGISTRY)/bborbe/backup-rsync-client:$(VERSION)

build:
	docker build --build-arg VENDOR_VERSION=$(VENDOR_VERSION) --no-cache --rm=true -t $(REGISTRY)/bborbe/backup-rsync-client:$(VERSION) -f ./Dockerfile .

run:
	docker run -p 8080:8080 $(REGISTRY)/bborbe/backup-rsync-client:$(VERSION)

shell:
	docker run -i -t --entrypoint /bin/bash $(REGISTRY)/bborbe/backup-rsync-client:$(VERSION)

upload:
	docker push $(REGISTRY)/bborbe/backup-rsync-client:$(VERSION)

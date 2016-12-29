VERSION ?= 1.0.0

default: build

clean:
	docker rmi bborbe/backup-rsync-client-build:$(VERSION)
	docker rmi bborbe/backup-rsync-client:$(VERSION)

setup:
	mkdir -p ./go/src/github.com/bborbe/backup
	git clone https://github.com/bborbe/backup.git ./go/src/github.com/bborbe/backup
	go get -u github.com/Masterminds/glide
	cd ./go/src/github.com/bborbe/backup && glide install

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o backup_rsync_client ./go/src/github.com/bborbe/backup/bin/backup_rsync_client

build:
	docker build --build-arg VERSION=$(VERSION) --no-cache --rm=true -t bborbe/backup-rsync-client-build:$(VERSION) -f ./Dockerfile.build .
	docker run -t bborbe/backup-rsync-client-build:$(VERSION) /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=bborbe/backup-rsync-client-build:$(VERSION) -f status=exited`:/backup_rsync_client .
	docker rm `docker ps -q -n=1 -f ancestor=bborbe/backup-rsync-client-build:$(VERSION) -f status=exited`
	docker build --no-cache --rm=true --tag=bborbe/backup-rsync-client:$(VERSION) -f Dockerfile.static .
	rm backup_rsync_client

run:
	docker run -p 8080:8080 bborbe/backup-rsync-client:$(VERSION)

shell:
	docker run -i -t --entrypoint /bin/bash bborbe/backup-rsync-client:$(VERSION)

upload:
	docker push bborbe/backup-rsync-client:$(VERSION)

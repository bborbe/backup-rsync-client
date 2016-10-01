default: build

clean:
	docker rmi bborbe/backup-rsync-client-build
	docker rmi bborbe/backup-rsync-client

setup:
	mkdir -p ./go/src/github.com/bborbe/backup
	git clone https://github.com/bborbe/backup.git ./go/src/github.com/bborbe/backup
	go get -u github.com/Masterminds/glide
	cd ./go/src/github.com/bborbe/backup && glide install

buildgo:
	CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o backup_rsync_client ./go/src/github.com/bborbe/backup/bin/backup_rsync_client

build:
	docker build --no-cache --rm=true -t bborbe/backup-rsync-client-build -f ./Dockerfile.build .
	docker run -t bborbe/backup-rsync-client-build /bin/true
	docker cp `docker ps -q -n=1 -f ancestor=bborbe/backup-rsync-client-build -f rsync-client=exited`:/backup_rsync_client .
	docker rm `docker ps -q -n=1 -f ancestor=bborbe/backup-rsync-client-build -f rsync-client=exited`
	docker build --no-cache --rm=true --tag=bborbe/backup-rsync-client -f Dockerfile.static .
	rm backup_rsync_client

run:
	docker run -p 8080:8080 bborbe/backup-rsync-client

upload:
	docker push bborbe/backup-rsync-client

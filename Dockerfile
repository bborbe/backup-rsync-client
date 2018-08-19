FROM golang:1.10 AS build
ARG VENDOR_VERSION
RUN git clone --branch ${VENDOR_VERSION} --single-branch --depth 1 https://github.com/bborbe/backup.git ./src/github.com/bborbe/backup
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-s" -a -installsuffix cgo -o /backup-rsync-client ./src/github.com/bborbe/backup/cmd/backup-rsync-client

FROM alpine:3.5
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

RUN apk add --update ca-certificates rsync openssh bash && rm -rf /var/cache/apk/*

ENV LOCK /backup_rsync_client.lock

COPY --from=build backup-rsync-client /
ENTRYPOINT ["/backup-rsync-client"]

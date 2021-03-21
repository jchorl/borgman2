FROM alpine

RUN apk add -q borgbackup
ENTRYPOINT ["/usr/bin/borg"]

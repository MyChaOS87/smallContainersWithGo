############################
# BUILD IMAGE
############################
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git ca-certificates tzdata musl-utils && update-ca-certificates
WORKDIR $GOPATH/src/github.com/mychaos87/smallContainersWithGo
COPY . .

RUN go get -d -v
RUN go build -o /go/bin/smallContainersWithGo

RUN ldd /go/bin/smallContainersWithGo | tr -s '[:blank:]' '\n' | grep '^/' | \
    xargs -I % sh -c 'mkdir -p $(dirname /dist%); cp % /dist%;'

############################
# RUN IMAGE
############################
FROM scratch

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/smallContainersWithGo /smallContainersWithGo
COPY --from=builder /dist /

ENTRYPOINT ["/smallContainersWithGo"]

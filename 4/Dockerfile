############################
# BUILD IMAGE
############################
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git tzdata
WORKDIR $GOPATH/src/github.com/mychaos87/smallContainersWithGo
COPY . .

RUN go get -d -v
RUN go build -o /go/bin/smallContainersWithGo

############################
# RUN IMAGE
############################
FROM scratch

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /go/bin/smallContainersWithGo /smallContainersWithGo

ENTRYPOINT ["/smallContainersWithGo"]


## NOT USABLE
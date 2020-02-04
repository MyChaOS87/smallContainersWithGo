############################
# BUILD IMAGE
############################
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/github.com/mychaos87/smallContainersWithGo
COPY . .

RUN go get -d -v
RUN go build -o /go/bin/smallContainersWithGo

############################
# RUN IMAGE
############################
FROM alpine

COPY --from=builder /go/bin/smallContainersWithGo /go/bin/smallContainersWithGo

ENTRYPOINT ["/go/bin/smallContainersWithGo"]

## Runs not as expected!
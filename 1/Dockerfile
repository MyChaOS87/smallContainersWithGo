FROM golang:alpine

RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/github.com/mychaos87/smallContainersWithGo
COPY . .

RUN go get -d -v
RUN go build -o /go/bin/smallContainersWithGo

ENTRYPOINT ["/go/bin/smallContainersWithGo"]

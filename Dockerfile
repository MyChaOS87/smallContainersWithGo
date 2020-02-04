############################
# BUILD IMAGE
############################
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git ca-certificates tzdata musl-utils && update-ca-certificates
WORKDIR $GOPATH/src/github.com/mychaos87/smallContainersWithGo
COPY . .

# Create appuser
ENV USER=appuser
ENV UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

RUN go get -d -v
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/smallContainersWithGo

# following line is necessary if your binary does not happen to have a dynamic dependency
RUN mkdir /dist
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

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

USER appuser:appuser

ENTRYPOINT ["/smallContainersWithGo"]

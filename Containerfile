FROM docker.io/library/golang:alpine AS builder
# 
LABEL org.opencontainers.image.source=https://github.com/skx/rss2email/

# Ensure we have git
RUN apk update && apk add --no-cache git

# checkout rss2email
RUN git clone https://github.com/skx/rss2email.git  $GOPATH/src/github.com/skx/rss2email/

# Create a working-directory
WORKDIR $GOPATH/src/github.com/skx/rss2email/

# Build the binary.
RUN go build -o /go/bin/rss2email

FROM alpine

RUN apk update && apk add --no-cache msmtp tini bash

# Create a working directory
WORKDIR /app

# Copy the binary.
COPY --from=builder /go/bin/rss2email /app/
ADD scripts/createMSMTPconfig.sh /createMSMTPconfig.sh
ADD scripts/entryPoint.sh /entryPoint.sh

RUN chmod +x /entryPoint.sh
RUN chmod +x /createMSMTPconfig.sh

ENTRYPOINT ["/sbin/tini", "--", "/entryPoint.sh"]
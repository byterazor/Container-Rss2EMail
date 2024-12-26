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

# we use msmtp as a dropin replacement for sendmail
RUN rm /usr/sbin/sendmail
RUN ln -s /usr/bin/msmtp /usr/sbin/sendmail

# add a user for running rss2email in the container
RUN addgroup rss2email && adduser -D -G rss2email rss2email

RUN mkdir -p /home/rss2email/.rss2email/

# ensure a homedirectory for the user exists and has correct access rights
RUN mkdir -p /home/rss2email  
RUN chown rss2email /home/rss2email
RUN chgrp rss2email /home/rss2email

# run everything as the rss2email user
USER rss2email

ENTRYPOINT ["/sbin/tini", "--", "/entryPoint.sh"]
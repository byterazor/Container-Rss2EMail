#!/bin/bash

/createMSMTPconfig.sh


if [ -z ${RECIPIENTS} ]; then
    echo "RECIPIENTS environment variable missing"
    exit 255
fi

if [ -z ${FEEDS} ]; then
    echo "FEEDS environment variable missing"
    exit 255
fi

mkdir -p ~/.rss2email/
echo ${FEEDS} > ~/.rss2email/feeds.txt

/app/rss2email daemon ${RECIPIENTS}
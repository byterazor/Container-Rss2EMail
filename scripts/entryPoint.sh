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


mkdir -p /home/rss2email/.rss2email/
echo -e ${FEEDS} > /home/rss2email/.rss2email/feeds.txt

/app/rss2email daemon ${RECIPIENTS}
#!/bin/bash

if  [ -z "${USE_MSMTP}" ]; then
    exit 0;
fi

if [ -z "${MSMTP_SMTP_HOST}" ]; then
    echo "missing required parameter <SMTP_HOST>"
    exit 255
fi

if [ -z "${MSMTP_SMTP_PORT}" ]; then
    MSMTP_SMTP_PORT=25
fi


if [ -z "${MSMTP_SMTP_FROM}" ]; then
    echo "missing required parameter <SMTP_FROM>"
    exit 255
fi

if [ -z "${MSMTP_SMTP_AUTH}" ]; then
    MSMTP_SMTP_AUTH=off
fi

if [ -z "${MSMTP_SMTP_TLS}" ]; then
    MSMTP_SMTP_TLS=off
fi


if [ "${MSMTP_SMTP_AUTH}" != "off" ]; then

    if [ -z "${MSMTP_SMTP_USER}" ]; then
        echo "missing required parameter <SMTP_USER>"
        exit 255
    fi

    if [ -z "${MSMTP_SMTP_PASS}" ]; then
        echo "missing required parameter <SMTP_PASS>"
        exit 255
    fi
else 
    MSMTP_SMTP_USER="dummy"
    MSMTP_SMTP_PASS="dummy"
fi

cat > /etc/msmtprc <<EOF
defaults
auth ${MSMTP_SMTP_AUTH}
tls ${MSMTP_SMTP_TLS}
logfile /dev/stdout

account default
host ${MSMTP_SMTP_HOST}
port ${MSMTP_SMTP_PORT}
from ${MSMTP_SMTP_FROM}
user ${MSMTP_SMTP_USER}
password ${MSMTP_SMTP_PASS}
EOF

chmod 600 /etc/msmtprc


# we use msmtp as a dropin replacement for sendmail
rm /usr/sbin/sendmail
ln -s /usr/bin/msmtp /usr/sbin/sendmail

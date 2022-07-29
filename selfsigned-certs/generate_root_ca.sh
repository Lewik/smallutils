#!/usr/bin/env bash

if openssl version | grep -i "LibreSSL" > /dev/null; then
  echo "openssl points to LibreSSL will generate old certificates, use OpenSSL instead of LibreSSL"
  exit 1
fi

if [ -z "$1" ]
then
  echo "Usage: $0 CA_NAME"
  exit 1
fi

CA_NAME="$1"

echo "Generate root ca key $CA_NAME.key"
`which openssl` genrsa \
  -out $CA_NAME.key \
  4096

echo "Generate root ca cert $CA_NAME.crt"
`which openssl` req \
  -x509 \
  -new \
  -nodes \
  -key $CA_NAME.key \
  -days 35600 \
  -subj "/C=RU/O=$CA_NAME" \
  -out $CA_NAME.crt

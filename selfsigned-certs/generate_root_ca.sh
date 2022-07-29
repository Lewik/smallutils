#!/usr/bin/env bash
# Constants

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

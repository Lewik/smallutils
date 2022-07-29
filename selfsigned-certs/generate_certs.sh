#!/usr/bin/env bash

if openssl version | grep -i "LibreSSL" > /dev/null; then
  echo "openssl points to LibreSSL will generate old certificates, use OpenSSL instead of LibreSSL"
  exit 1
fi

if [ -z "$3" ]
then
  echo "Usage: $0 CA_NAME domain_name ip_address"
  exit 1
fi

CA_NAME="$1"
DOMAIN="$2"
IP_ADDRESS="$3"

cat > "$DOMAIN".conf << EOF
[req]
default_bits  = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
x509_extensions = v3_req
prompt = no
[req_distinguished_name]
countryName = RU
stateOrProvinceName = N/A
localityName = N/A
organizationName = $CA_NAME
commonName = $DOMAIN, $IP_ADDRESS: Self-signed certificate
[req_ext]
subjectAltName = @alt_names
[v3_req]
subjectAltName = @alt_names
[alt_names]
IP.1 = 127.0.0.1
IP.2 = $IP_ADDRESS
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
EOF

echo "Generate key."
`which openssl` \
  genrsa \
  -out "$DOMAIN".key \
  2048

echo "Generate csr."
`which openssl` \
  req -new\
  -key "$DOMAIN".key \
  -out "$DOMAIN".csr \
  -config $DOMAIN.conf

echo "Generate cert."
`which openssl` x509 \
  -req \
  -in $DOMAIN.csr \
  -CA $CA_NAME.crt \
  -CAkey $CA_NAME.key \
  -CAcreateserial \
  -out $DOMAIN.crt \
  -days 825 \
  -extensions v3_req \
  -extfile $DOMAIN.conf

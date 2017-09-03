#!/bin/sh
# Generate CA using ipsec pki tools

if [ $# != 1 ]; then
   echo "Usage: $0 <DN>"
   echo "i.e.: $0 'C=GB,O=Strongswan,CN=Strongswan CA'"
   exit 1
fi

if [ -z $PKI_ROOT ]; then
    echo "Set PKI_ROOT environment variable before running this script"
    exit 1
fi

if [ ! -d "$PKI_ROOT/ca" ]; then
    mkdir -p $PKI_ROOT/ca
fi

echo "Generating CA key"
if [ "$QUICK_KEY_GEN" = "false" ]; then
   ipsec pki --gen --outform pem > $PKI_ROOT/ca/caKey.pem
else
   openssl genrsa -out $PKI_ROOT/ca/caKey.pem 1024 2>/dev/null 1>/dev/null
fi
echo "Generating CA self-signed certificate"
ipsec pki --self --in $PKI_ROOT/ca/caKey.pem --dn "$1" --ca --outform pem > $PKI_ROOT/ca/caCert.pem

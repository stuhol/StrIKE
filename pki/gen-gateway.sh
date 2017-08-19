#!/bin/sh
# Generate gateway key and certificate using the provided DN

if [[ $# != 2 ]]; then
   echo "Usage: $0 <DN> <SAN>"
   echo "i.e.: $0 'C=GB, O=Strongswan, CN=10.0.0.1' 10.0.0.1"
   exit 1
fi

if [[ -z $PKI_ROOT ]]; then
    echo "Set PKI_ROOT environment variable before running this script"
    exit 1
fi

if [[ ! -d $PKI_ROOT/ca ]]; then
    echo "ca directory not found, have you generated a CA yet?"
    exit 1
fi

if [[ ! -d $PKI_ROOT/gateway ]]; then
    mkdir -p $PKI_ROOT/gateway
fi

echo "Generating gateway key"
if [[ "$QUICK_KEY_GEN" == "false" ]]; then
   ipsec pki --gen --outform pem > $PKI_ROOT/gateway/gatewayKey.pem
else
   openssl genrsa -out $PKI_ROOT/gateway/gatewayKey.pem 1024 2>/dev/null 1>/dev/null
fi

echo "Creating gateway certificate signed by CA"
ipsec pki --pub --in $PKI_ROOT/gateway/gatewayKey.pem | ipsec pki --issue --cacert $PKI_ROOT/ca/caCert.pem --cakey $PKI_ROOT/ca/caKey.pem --dn "$1" --san "$2" --flag serverAuth --flag ikeIntermediate --outform pem > $PKI_ROOT/gateway/gatewayCert.pem

echo "Finished"

#!/bin/sh
# Generate client certificate given the provided CN and filename

if [ $# != 2 ]; then
   echo "Usage: $0 <DN> <output PKCS12 path>"
   echo "i.e.: $0 'C=GB, O=StrongSwan, CN=client' client.p12"
   exit 1
fi

if [ -z $PKI_ROOT ]; then
    echo "Set PKI_ROOT environment variable before running this script"
    exit 1
fi

if [ ! -d "$PKI_ROOT/ca" ]; then
    echo "pki directory not found, have you generated a CA yet?"
    exit 1
elif [ ! -d "$PKI_ROOT/gateway" ]; then
    echo "gateway directory not found, make sure you generate a gateway cert too, continuing anyway..."
fi

if [ ! -d "$PKI_ROOT/clients" ]; then
    mkdir -p $PKI_ROOT/clients
fi

CN=`echo $1 | sed -n 's/.*CN=\(.*\)/\1/p'`
echo "Using CN $CN"

echo "Generating client key"
if [ "$QUICK_KEY_GEN" = "false" ]; then
   ipsec pki --gen --outform pem > $PKI_ROOT/clients/${CN}Key.pem
else
   openssl genrsa -out $PKI_ROOT/clients/${CN}Key.pem 1024 2>/dev/null 1>/dev/null
fi


echo "Generating client certificate signed by CA"
ipsec pki --pub --in $PKI_ROOT/clients/${CN}Key.pem | ipsec pki --issue --cacert $PKI_ROOT/ca/caCert.pem --cakey $PKI_ROOT/ca/caKey.pem --dn "$1" --san "$CN" --outform pem > $PKI_ROOT/clients/${CN}Cert.pem
echo "Creating PKCS12 file"
openssl pkcs12 -export -passout pass: -inkey $PKI_ROOT/clients/${CN}Key.pem -in $PKI_ROOT/clients/${CN}Cert.pem -certfile $PKI_ROOT/ca/caCert.pem -out $2

echo "Finished"

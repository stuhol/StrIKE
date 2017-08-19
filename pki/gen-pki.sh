#!/bin/sh

function checkRet {
  "$@"
  ret=$?
  if [[ $ret != 0 ]]; then
    echo "Error - Unable to execute '$@' - Return code $ret"
    exit $ret
  fi
}

if [[ -z $PKI_ROOT ]]; then
    export PKI_ROOT=/tmp/pki/
fi

# Generate CA key and certificate
checkRet ./gen-ca.sh 'O=StrIKE,CN=StrIKE CA'

# Get IP
ip=`checkRet wget -q -O - https://api.ipify.org/` 

# Generate gateway key and certificate, then sign with CA 
checkRet ./gen-gateway.sh 'O=StrIKE,CN=$ip' '$ip'

# Generate client key and certificate, then sign with CA
checkRet ./gen-client.sh 'O=StrIKE,CN=client' /tmp/pki/clients/client.p12

# Serve the client certificate ready for download
echo "You can download your client certificate package here: http://$ip:8000"
/tmp/StrIKE-master/dashboard/serve -d /tmp/pki/clients &
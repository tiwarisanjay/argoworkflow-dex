#!/bin/bash
lb=$1
[ -d ssl ] && rm -rf ssl
mkdir ssl 
cd ssl
[ ! -z $lb ] && ip2="IP.2 = ${lb}" || ip2=""

cat > csr.conf <<EOF
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = GA
L = Atlanta
O = SanjTiwa
OU = SanjTiwa Dev
CN = kube-ca

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = localhost
IP.1 = 127.0.0.1
${ip2}
EOF

openssl req -x509 \
            -sha256 -days 10 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=kube-ca/C=US/L=Atlanta/O=SanjTiwa/OU=SanjTiwa Dev" \
            -keyout rootCA.key -out rootCA.crt

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -config csr.conf

cat > cert.conf <<EOF

authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
IP.1 = 127.0.0.1
${ip2}
EOF

openssl x509 -req \
    -in server.csr \
    -CA rootCA.crt -CAkey rootCA.key \
    -CAcreateserial -out server.crt \
    -days 365 \
    -sha256 -extfile cert.conf

cd ../
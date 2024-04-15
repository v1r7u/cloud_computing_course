# Certificates

The goal: inspect real certificates content, generate a sample one

1. Certificates are used to identify an Entity. To prove the identification, there is a certificate chain: leaf, intermediate, and root certs.

    - open any website and show certificate: subject, alternative names, valid to/from, trust-chain
    - get certificate from terminal and compare : `echo | openssl s_client -servername github.com -connect github.com:443 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > certificate.pem` OR `openssl s_client -showcerts -connect github.com:443`

    By default, your browser accepts certificates that have trusted Certificate Authority in its trust-chain. You can _trust_ other authoirities too, but you have to add them to truststore first.

    Certificates could be self-signed - no CA verified it.

    Certificates have expiration dates. Root certificates often are valid 10+ years, while leaf certificates - less than a year.

2. Create a sample Certificate Authority and sign a certificate.

```sh
# root certificate with RSA key
openssl genpkey -algorithm RSA -out root.key -pkeyopt rsa_keygen_bits:3072

openssl req -x509  -new -nodes \
    -key root.key \
    -days 3650 \
    -out root.pem \
    -subj "/C=UA/CN=CloudComputing"

# to read certificate content:
openssl x509 -text -noout -in root.pem

# leaf private key with EC (Elliptic Curve) Key
# note, length of the key is significantly shorter, but offers the same cryptographic strength
# it is also  more efficient in terms of computation, storage, and bandwidth
openssl genpkey -algorithm EC -out leaf.key -pkeyopt ec_paramgen_curve:prime256v1

# leaf certificate request which could be sent to CA for signing
openssl req -new -key leaf.key \
    -out leaf.csr \
    -subj "/C=UA/CN=example.com"

openssl req -noout -text -in leaf.csr

openssl x509 -req \
    -in leaf.csr \
    -extensions server_ext \
    -CA root.pem \
    -CAkey root.key \
    -CAcreateserial \
    -out leaf.pem \
    -days 365 \
    -extfile \
    <(echo "[server_ext]"; echo "extendedKeyUsage=serverAuth,clientAuth"; echo "subjectAltName=DNS.1:example.com,DNS.2:*.example.com")

openssl x509 -text -noout -in leaf.pem

# check subject (!) hashes
openssl x509 -in leaf.pem -noout -hash -issuer_hash
openssl x509 -in root.pem -noout -hash -issuer_hash

# verify if certificate is signed by given CA
openssl verify -CAfile root.pem leaf.pem
```

## Further reading:

- [A complete overview of SSL/TLS and its cryptographic system](https://dev.to/techschoolguru/a-complete-overview-of-ssl-tls-and-its-cryptographic-system-36pd)
- [Public Key Infrastructure](https://smallstep.com/blog/everything-pki/)
- [Illustrated X.509 Certificate](https://darutk.medium.com/illustrated-x-509-certificate-84aece2c5c2e)

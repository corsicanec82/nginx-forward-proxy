#!/bin/bash

set -e

cp /proxy/nginx.conf /usr/local/nginx/conf/nginx.conf
cp /proxy/proxy_auth.lua /usr/local/nginx/conf/proxy_auth.lua

if [ -z "${PROXY_USERNAME}" ] || [ -z "${PROXY_PASSWORD}" ]; then
  PROXY_USERNAME=proxyuser;
  PROXY_PASSWORD=proxypassword;
fi
echo "$PROXY_USERNAME:$(openssl passwd -apr1 $PROXY_PASSWORD)" > /usr/local/nginx/.htpasswd

exec "$@"

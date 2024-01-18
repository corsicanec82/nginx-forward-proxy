#!/bin/bash

set -e

cp /proxy/nginx.conf /usr/local/nginx/conf/nginx.conf
cp /proxy/proxy_auth.lua /usr/local/nginx/conf/proxy_auth.lua

if [ -z "${VAR}" ]; then
  PROXY_HTPASSWD="proxyuser:$apr1$8mevoxsb$GITB95.KGfEV7OSplVDWY."
fi
echo $PROXY_HTPASSWD > /usr/local/nginx/.htpasswd

exec "$@"

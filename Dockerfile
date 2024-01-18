# https://github.com/hinata/nginx-forward-proxy
# https://github.com/chobits/ngx_http_proxy_connect_module
# https://github.com/openresty/lua-nginx-module
# basic auth for proxy including https
# https://github.com/chobits/ngx_http_proxy_connect_module/issues/42#issuecomment-502985437

FROM alpine:3.18.5

ARG NGINX_VERSION=1.25.3
ARG PROXY_MODULE_VERSION=0.0.5
ARG LUA_MODULE_VERSION=0.10.25
ARG LUA_RESTY_CORE_VERSION=0.1.27
ARG LUA_RESTY_LRUCACHE_VERSION=0.13

WORKDIR /tmp

RUN apk update && apk add \
      openssl-dev \
      pcre-dev \
      zlib-dev \
      bash \
      wget \
      patch \
      g++ \
      make \
      luajit-dev \
      openssl

RUN wget https://github.com/openresty/lua-nginx-module/archive/refs/tags/v$LUA_MODULE_VERSION.tar.gz \
  -O lua-nginx-module-$LUA_MODULE_VERSION.tar.gz \
  && tar -xf lua-nginx-module-$LUA_MODULE_VERSION.tar.gz

RUN wget https://github.com/chobits/ngx_http_proxy_connect_module/archive/refs/tags/v$PROXY_MODULE_VERSION.tar.gz \
  -O ngx_http_proxy_connect_module-$PROXY_MODULE_VERSION.tar.gz \
  && tar -xf ngx_http_proxy_connect_module-$PROXY_MODULE_VERSION.tar.gz

RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
  && tar -xf nginx-$NGINX_VERSION.tar.gz

ENV LUAJIT_LIB /usr/lib
ENV LUAJIT_INC /usr/include/luajit-2.1

RUN cd nginx-$NGINX_VERSION \
  && patch -p1 < ../ngx_http_proxy_connect_module-$PROXY_MODULE_VERSION/patch/proxy_connect_rewrite_102101.patch \
  && ./configure \
    --add-module=../ngx_http_proxy_connect_module-$PROXY_MODULE_VERSION \
    --sbin-path=/usr/sbin/nginx \
    --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
    --add-module=../lua-nginx-module-$LUA_MODULE_VERSION \
    --with-ld-opt="-Wl,-rpath,/usr/lib" \
  && make -j $(nproc) \
  && make install

RUN wget https://github.com/openresty/lua-resty-core/archive/refs/tags/v$LUA_RESTY_CORE_VERSION.tar.gz \
  -O lua-resty-core-$LUA_RESTY_CORE_VERSION.tar.gz \
  && tar -xf lua-resty-core-$LUA_RESTY_CORE_VERSION.tar.gz \
  && cd lua-resty-core-$LUA_RESTY_CORE_VERSION \
  && make install PREFIX=/usr/local/nginx

RUN wget https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v$LUA_RESTY_LRUCACHE_VERSION.tar.gz \
  -O lua-resty-lrucache-$LUA_RESTY_LRUCACHE_VERSION.tar.gz \
  && tar -xf lua-resty-lrucache-$LUA_RESTY_LRUCACHE_VERSION.tar.gz \
  && cd lua-resty-lrucache-$LUA_RESTY_LRUCACHE_VERSION \
  && make install PREFIX=/usr/local/nginx

RUN rm -rf /tmp/*

WORKDIR /proxy

COPY ["nginx.conf", "proxy_auth.lua", "entrypoint.sh", "."]

ENTRYPOINT ["/proxy/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 51820/tcp

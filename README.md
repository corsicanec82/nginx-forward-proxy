# nginx-forward-proxy
*self-hosted proxy server*

### Requirements:
  - docker

## Using

1. Generate username and password hash pair. You may to use online services for it. For example: https://wtools.io/generate-htpasswd-online

2. Run proxy server with setting up PROXY_HTPASSWD

    ```bash
    docker run -d \
      -e PROXY_HTPASSWD="username and password hash pair" \
      -p 51820:51820 \
      corsicanec82/nginx-forward-proxy
    ```

    If PROXY_HTPASSWD is not presented, you can use default username and password:

    ```text
    proxyuser
    proxypassword
    ```

3. Set up a local connection via a proxy server

    ```text
    http://username:password@host:51820
    ```

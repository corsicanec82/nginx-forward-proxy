# nginx-forward-proxy
*self-hosted proxy server*

### Requirements:
  - docker

## Using

1. Run proxy server with setting up PROXY_USERNAME and PROXY_PASSWORD environment variables

    ```bash
    docker run -d \
      -e PROXY_USERNAME="username" \
      -e PROXY_PASSWORD="password" \
      -p 51820:51820 \
      corsicanec82/nginx-forward-proxy
    ```

    If PROXY_USERNAME or PROXY_PASSWORD are not presented, you can use default username and password:

    ```text
    proxyuser
    proxypassword
    ```

2. Set up a local connection via a proxy server

build:
	docker build -t corsicanec82/nginx-forward-proxy .

push:
	docker push corsicanec82/nginx-forward-proxy

bash:
	docker run --rm -it corsicanec82/nginx-forward-proxy /bin/bash

run:
	docker run --rm -p 51820:51820 corsicanec82/nginx-forward-proxy

FROM kong:2.4

USER root

RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/local/openresty/nginx/sbin/nginx
RUN luarocks install --server=https://luarocks.org/dev ltn12
# RUN luarocks install https://raw.githubusercontent.com/nodis-com-br/nodis-oidc/master/nodis-oidc-0.1.0-0.rockspec
# RUN luarocks install https://raw.githubusercontent.com/nodis-com-br/github-auth/master/github-auth-0.1.0-0.rockspec
# RUN luarocks install ./jwt-header-forward-kong-plugin-0.1.0-0.rockspec

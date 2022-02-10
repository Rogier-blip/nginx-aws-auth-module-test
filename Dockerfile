FROM alpine:3.12.0 AS base_image

FROM base_image AS build

RUN apk add --no-cache curl build-base openssl openssl-dev zlib-dev linux-headers pcre-dev ffmpeg ffmpeg-dev
RUN mkdir nginx nginx-aws-auth-module

ARG NGINX_VERSION=1.16.1
# Commit relate to a certain release from nginx-aws-auth-module
ARG AWS_AUTH_MODULE_VERSION=dbbac974f0699328a63f497cd911a4f991faed9b

RUN curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -C /nginx --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-aws-auth-module/archive/${AWS_AUTH_MODULE_VERSION}.tar.gz | tar -C /nginx-aws-auth-module --strip 1 -xz

WORKDIR /nginx
RUN ./configure --prefix=/usr/local/nginx \
	--add-module=../nginx-aws-auth-module \
	--with-http_ssl_module \
	--with-file-aio \
	--with-threads \
	--with-cc-opt="-O3"
RUN make
RUN make install
RUN rm -rf /usr/local/nginx/html /usr/local/nginx/conf/*.default

FROM base_image
RUN apk add --no-cache ca-certificates openssl pcre zlib ffmpeg

COPY --from=build /usr/local/nginx /usr/local/nginx

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf

ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]


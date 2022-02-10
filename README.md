# Setup
These commands can be used to build the docker image and run the docker image.

## Docker build
`docker build . -t nginx-aws-auth`

## Docker run
`docker run -p 3000:80 nginx-aws-auth`

## Result

`nginx: [emerg] unknown directive "aws_auth_presign" in /usr/local/nginx/conf/nginx.conf:9`. This is the result of running the command.

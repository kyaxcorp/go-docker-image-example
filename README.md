# go-docker-image-example

# BUILD APP
docker build --tag go-docker-image-example .

# BUILD AND CREATE PRODUCTION RELEASE IMAGE
docker build --tag go-docker-image-example:release -f Dockerfile.release .
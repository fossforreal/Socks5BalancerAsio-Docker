# Setup builder image based on Alpine linux
FROM alpine AS build
WORKDIR /

# Install required packages
RUN apk update && apk upgrade && apk add git linux-headers cmake make openssl-dev gcc g++

# Copy script
COPY ./build.sh /build.sh

# Make it executable
RUN chmod +x /build.sh

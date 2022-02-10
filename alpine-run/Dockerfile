# Setup builder image based on Alpine linux
FROM alpine
WORKDIR /

# Install required packages
RUN apk update && apk upgrade && apk add libstdc++

# Copy necessary files
COPY ./entry.sh /entry.sh
COPY ./Socks5BalancerAsio /Socks5BalancerAsio

# Make them executable
RUN chmod +x /entry.sh && chmod +x /Socks5BalancerAsio

# This is entrypoint obviously ;)
ENTRYPOINT /entry.sh
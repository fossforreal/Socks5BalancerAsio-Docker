#!/bin/sh

# Install (compile from sources) Socks5BalancerAsio
cd /Socks5BalancerAsio
cmake .
make -j$(nproc)

# Copy binary to output directory
cp /Socks5BalancerAsio/Socks5BalancerAsio /output/
cp /Socks5BalancerAsio/Socks5BalancerAsio /output/Socks5BalancerAsio.original
strip /output/Socks5BalancerAsio
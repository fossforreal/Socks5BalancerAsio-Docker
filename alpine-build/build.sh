#!/bin/sh

# Configure & compile Boost library
cd boost_1_73_0
./bootstrap.sh
./b2 link=static
cd ..

# Install (compile from sources) Socks5BalancerAsio
PATH=/boost_1_73_0:/boost_1_73_0/stage/lib:$PATH
cd /Socks5BalancerAsio
cmake .
make -j$(nproc)

# Copy binary to output directory
cp /Socks5BalancerAsio/Socks5BalancerAsio /output/
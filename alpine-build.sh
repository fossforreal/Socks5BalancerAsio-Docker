#!/bin/sh

# Download sources into build directory 
cd alpine-build

# Boost - v1.73.0
wget -nc https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2
echo Unpacking Boost archive
tar --skip-old-files -jxf boost_1_73_0.tar.bz2
echo Done unpacking

# Socks5BalancerAsio - v1.0 (commit - e6c491ce56f6de21423c5d780d1c8865714fabe3)
git clone https://github.com/Socks5Balancer/Socks5BalancerAsio
cd Socks5BalancerAsio
git checkout e6c491ce56f6de21423c5d780d1c8865714fabe3
cd ..

# Build builder docker image
docker build -t socks5balancerasio-build .

# Run builder to output binary
mkdir output
docker run -v $(pwd)/boost_1_73_0:/boost_1_73_0 -v $(pwd)/Socks5BalancerAsio:/Socks5BalancerAsio -v $(pwd)/output:/output socks5balancerasio-build /build.sh

# Then finally build runner image
cd ..
cd alpine-run
cp ../alpine-build/output/Socks5BalancerAsio ./Socks5BalancerAsio
strip ./Socks5BalancerAsio
docker build -t socks5balancerasio .

# Prepare files for demo run
cd ..
cp -r alpine-build/Socks5BalancerAsio/html/ ./html
cp alpine-build/Socks5BalancerAsio/example-config/FullConfig.json ./config.json

# Give help on how to use this & demo
echo
echo We have successfully built Socks5BalancerAsio
echo \(hopefully you have not encountered any errors\)
echo
echo Resulting image: $(docker images socks5balancerasio:latest --format "{{.Repository}}:{{.Tag}} -> {{.Size}}")
echo
echo You can test it by running:
echo
echo docker run -v \$\(pwd\)/html:/html -v \$\(pwd\)/config.json:/config.json -it socks5balancerasio
echo

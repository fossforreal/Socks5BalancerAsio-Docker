#!/bin/sh

TAG=socks5balancerasio
TAGB=socks5balancerasio-build

# Download sources into build directory 
cd alpine-build

# Socks5BalancerAsio - v1.1 (with fix in commit - 37b8cff06bdb7f8c892754e2c8fcf5dc743cf31c)
git clone https://github.com/fossforreal/Socks5BalancerAsio
cd Socks5BalancerAsio
#git checkout 37b8cff06bdb7f8c892754e2c8fcf5dc743cf31c
cd ..

# Build builder docker image
docker build -t $TAGB .

# Run builder to output binary
mkdir output
docker run -v $(pwd)/Socks5BalancerAsio:/Socks5BalancerAsio -v $(pwd)/output:/output $TAGB /build.sh

# Then finally build runner image
cd ..
cd alpine-run
cp ../alpine-build/output/Socks5BalancerAsio ./Socks5BalancerAsio
# strip ./Socks5BalancerAsio # NOW THIS IS RUN IN "BUILDER" DOCKER CONTAINER
docker build -t $TAG .

# Prepare files for demo run
cd ..
cp -r alpine-build/Socks5BalancerAsio/html/ ./html
cp alpine-build/Socks5BalancerAsio/example-config/FullConfig.json ./config.json

# Give help on how to use this & demo
echo
echo We have successfully built Socks5BalancerAsio
echo \(hopefully you have not encountered any errors\)
echo
echo Resulting image: $(docker images $TAG --format "{{.Repository}}:{{.Tag}} -> {{.Size}}")
echo
echo You can test it by running:
echo
echo docker run -v \$\(pwd\)/html:/html -v \$\(pwd\)/config.json:/config.json -it $TAG
echo

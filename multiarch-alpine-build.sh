#!/bin/sh

TAG=socks5balancerasio
TAGB=socks5balancerasio-build
PLATFORM=("linux/amd64" "linux/arm64" "linux/arm/v7")
ARCH=("amd64" "arm64" "arm-v7")

# Check for & setup Docker BuildX to perform multi-architecture build
docker buildx create --name multiarchbuilder --platform linux/amd64,linux/arm64,linux/arm/v7
docker buildx use multiarchbuilder
docker buildx inspect --bootstrap

# Download sources into build directory 
cd alpine-build

# Socks5BalancerAsio - v1.1 (with fixes)
git clone https://github.com/fossforreal/Socks5BalancerAsio
cd Socks5BalancerAsio
#git checkout 37b8cff06bdb7f8c892754e2c8fcf5dc743cf31c
cd ..


# For each PLATFORM <=> ARCH perform build
for idx in {0..2}; do

    echo Building \"builder\" image for platform \"${PLATFORM[$idx]}\" and architecture \"${ARCH[$idx]}\"
    sleep 1

    cp -r Socks5BalancerAsio Socks5BalancerAsio-${ARCH[$idx]}

    # Build builder docker image
    docker buildx build --platform ${PLATFORM[$idx]} --load -t $TAGB:latest-${ARCH[$idx]} .

    # Run builder to output binary
    mkdir output-${ARCH[$idx]}
    docker run -v $(pwd)/Socks5BalancerAsio:/Socks5BalancerAsio -v $(pwd)/output-${ARCH[$idx]}:/output $TAGB:latest-${ARCH[$idx]} /build.sh

done;

# Then finally build runner image
cd ..
cd alpine-run

# For each PLATFORM <=> ARCH perform build
for idx in {0..2}; do

    echo Building \"runner\" image for platform \"${PLATFORM[$idx]}\" and architecture \"${ARCH[$idx]}\"
    sleep 1

    mkdir ${ARCH[$idx]}
    cd ${ARCH[$idx]}
    cp ../../alpine-build/output-${ARCH[$idx]}/Socks5BalancerAsio ./
    cp ../entry.sh ./
    cp ../Dockerfile ./

    docker buildx build --platform ${PLATFORM[$idx]} --load -t $TAG:latest-${ARCH[$idx]} .
    cd ..

done;

# Prepare files for demo run
cd ..
cp -r alpine-build/Socks5BalancerAsio/html/ ./html
cp alpine-build/Socks5BalancerAsio/example-config/FullConfig.json ./config.json

# Give help on how to use this & demo
echo
echo We have successfully built Socks5BalancerAsio
echo \(hopefully you have not encountered any errors\)
echo
echo Resulting images:

# For each PLATFORM <=> ARCH perform build
for idx in {0..2}; do

    echo Platform \"${PLATFORM[$idx]}\", arch \"${ARCH[$idx]}\" \=\> $(docker images $TAG:latest-${ARCH[$idx]} --format "{{.Repository}}:{{.Tag}} -> {{.Size}}")

done;

echo
echo You can test them by running \(ARCH = amd64, arm64, arm-v7\):
echo
echo docker run -v \$\(pwd\)/html:/html -v \$\(pwd\)/config.json:/config.json -it $TAG:latest-ARCH
echo
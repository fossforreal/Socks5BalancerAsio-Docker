# Socks5BalancerAsio Docker version

This is repository for scripts building a Docker image for [Socks5BalancerAsio](https://github.com/Socks5Balancer/Socks5BalancerAsio) using **Alpine linux** image for minimal size (~20 MB).

Scripts do the following:
 - Download sources for building (Boost 1.74+ and [fossforreal/Socks5BalancerAsio v1.1](git clone https://github.com/fossforreal/Socks5BalancerAsio) ~~Boost-1.73.0 and Socks5BalancerAsio-1.0~~)
 - Build "builder" alpine image
 - Build Boost libs and Socks5BalancerAsio using it
 - Build "runner" alpine image with stripped binary
 - Provide you with image and command to use it

> --- 
> ***Warning!***
> 
> If sources are not downloading or you have problems with file permissions
> assume that this should be running in Docker with ```root``` priviledges.
> ---
> Also you should have following utils: ```wget, tar, bzip2, git, strip, docker```
>
> ---
> Keep in mind that compilation uses all cores ```make -j$(nproc)```, so make sure not to burn your CPU.
>
> ---
 
## To perform the build process:

 1. Clone repository:
```bash
git clone https://github.com/fossforreal/Socks5BalancerAsio-Docker
```
 2. Run script:
```bash
chmod +x ./alpine-build.sh && ./alpine-build.sh
```
 3. Then you will have Docker image ```socks5balancerasio:latest```
 4. You can run it interactively like this (or if in background, replace ```-it``` with ```-d```:
 ```bash
 docker run -v $(pwd)/html:/html -v $(pwd)/config.json:/config.json -it socks5balancerasio
 ```
 
## TO USE IMAGE SEPARATELY (FROM DOCKER HUB):

 1. Clone repository (you need ```html``` folder and ```config.json```) into somewhere (may be ```/tmp```):
```bash
git clone https://github.com/Socks5Balancer/Socks5BalancerAsio
```
 2. Get required files to desired folder ```somewhere```:
```bash
cp -r Socks5BalancerAsio/html somewhere/html
cp Socks5BalancerAsio/example-config/FullConfig.json somewhere/config.json
cd somewhere
```
 3. Adjust ```config.json``` and run image:
```bash
docker run -v $(pwd)/html:/html -v $(pwd)/config.json:/config.json -it fossforreal/socks5balancerasio
```
 
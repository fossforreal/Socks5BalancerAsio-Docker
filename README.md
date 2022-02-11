# Socks5BalancerAsio Docker version

This is repository for scripts building a Docker image for [Socks5BalancerAsio](https://github.com/Socks5Balancer/Socks5BalancerAsio) using **Alpine linux** image for minimal size (~20 MB).

See on DockerHub: [fossforreal/socks5balancerasio](https://hub.docker.com/r/fossforreal/socks5balancerasio/)

> Currently image on DockerHub was built and tested for ```amd64``` (tag ```latest, latest-amd64```) architecture.
> 
> Other ```arm64, arm/v7``` are available with tags ```latest-arm64, latest-arm-v7```, but were not tested.

## TL;DR (How to use image from DockerHub)
```bash
git clone https://github.com/Socks5Balancer/Socks5BalancerAsio
cd Socks5BalancerAsio
cp example-config/FullConfig.json config.json
```
```bash
docker run -v $(pwd)/html:/html -v $(pwd)/config.json:/config.json \
    -p 5000:5000 -p 5002:5002 -p 5010:5010 -it fossforreal/socks5balancerasio:latest
```
For configuration options **scroll down and read section ```# Configuration```**, also check [Socks5BalancerAsio README.md](https://github.com/Socks5Balancer/Socks5BalancerAsio/blob/master/README.md)

> Image with tag "v1.1" or "latest" uses Boost v1.77, while "v1.0" uses Boost v1.73.

## For developers:

Scripts do the following:
 - Download sources for building (Boost 1.74+ and [fossforreal/Socks5BalancerAsio v1.1](https://github.com/fossforreal/Socks5BalancerAsio) ~~Boost-1.73.0 and Socks5BalancerAsio-1.0~~)
 - Build "builder" alpine image
 - Build ~~Boost libs and~~ Socks5BalancerAsio using it
 - Build "runner" alpine image with stripped binary
 - Provide you with an image and command to use it

All of this is available for ```amd64, arm64, arm/v7``` architectures (see **```# Other architectures```**).

To use Boost v1.73 and previous version checkout this repo at tag v1.0, i.e. commit - d76346b2631cdc39221d40013fb9ab76e6d4ced1.

> --- 
> ***Warning!***
> 
> If sources are not downloading or you have problems with file permissions
> assume that this should be running in Docker with ```root``` priviledges.
> 
> Also you should have following utils: ```wget, git, docker``` (```tar, bzip2``` only for Boost-1.73)
>
> Keep in mind that compilation uses all cores ```make -j$(nproc)```, so make sure not to burn your CPU.
>
> ---
 
## To perform the build process (amd64):

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
 docker run -v $(pwd)/html:/html -v $(pwd)/config.json:/config.json \
     -p 5000:5000 -p 5002:5002 -p 5010:5010 -it socks5balancerasio
 ```

## Other architectures

> Prerequisites: Docker installed with BuildX plugin (on Debian, Redhat, Arch it is by default, see [Docker Docs](https://docs.docker.com/buildx/working-with-buildx/))

Same thing as ```amd64``` but use other script (it builds ```amd64, arm64, arm/v7```):
```bash
chmod +x ./multiarch-alpine-build.sh && ./multiarch-alpine-build.sh
```

After that you will have Docker images ```socks5balancerasio:latest-{amd64,arm64,arm-v7}```.
 
## How to use manually built image:

 1. Clone repository (you need ```html``` folder and ```config.json```) into somewhere (may be ```/tmp```):
 2. Adjust ```config.json```
 3. Run image
```bash
docker run -v $(pwd)/html:/html -v $(pwd)/config.json:/config.json \
    -p 5000:5000 -p 5002:5002 -p 5010:5010 -it socks5balancerasio:latest
```

## Configuration

Ports you need to publish (i.e. ```5000,5002,5010```...) come from config options:
```json
...
    "listenPort": 5000,
    "stateServerPort": 5010,
    "EmbedWebServerConfig": {
        ...
        "port": 5002,
        ...
    },
    "multiListen": [
        ... {
        "port": 6010,
        } ...
    ]
...
```
 
To be able to publish (and access) these ports you should have options set as follows:
```json
 ...
 "listenHost": "0.0.0.0",
 "stateServerHost": "0.0.0.0",
 "EmbedWebServerConfig": {
    ...
    "host": "0.0.0.0",
    ...
 }
 ...
```
and if you have ```multiListen``` option as well:
```json
"multiListen": [
    ... {
      "host": "0.0.0.0",
    } ...
 ]
 ...

```

## Donate

If my work somehow helped you, consider crypto donation in XMR (Monero) to this address:
```
84oCTQkSHL1AQMsGHWeJG6H3SdScdTCHpFsK75y4rms2KwtMkH3fSECJ3jiD5PVpJaQtKhtUDZANvb8DfV6iY6VrJ6xLkdA
```

## License

*(c) **fossforreal***, [GNU GPLv3](LICENSE)

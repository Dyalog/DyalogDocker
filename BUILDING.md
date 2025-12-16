# Building Dyalog Containers

The Dockerfile now allows for building x86_64 (AMD64) along with aarch64 (ARM64) containers.

To build both AMD64 / ARM64 containers you will need to use `docker buildx` for more information on this you can see the Docker documentation here: https://docs.docker.com/build/building/multi-platform/

## Enable bulti-platform building
```
    if ! docker buildx ls | grep multi-arch-builder ; then
        docker run --privileged --rm tonistiigi/binfmt --install all
        docker buildx create --use --name multi-arch-builder
    fi
```

## Build dyalog for linux/amd64 & linux/arm64
You will need to change the --tag to match your own docker registry in the below command to build / publish your own containers.

```
docker buildx build --no-cache --pull  --provenance=true --sbom=true  --platform linux/amd64,linux/arm64 --tag dockerregistry/dyalog --progress=plain --push .
```

## Building without multi-arch support

To build the containers locally without using multi-arch builds you can use the following:

```
docker build --build-arg TARGETPLATFORM="linux/amd64" -t dyalog .
```

This will build a container named `dyalog:latest` on the local system with only support for amd64, you can replace `amd64` with `arm64` if you wish to run ARM64 builds.
#!/bin/sh
container=openwrt-builder

sudo DOCKER_BUILDKIT=1 docker build \
            --build-arg "https_proxy=http://192.168.1.1:7890" \
            --build-arg "http_proxy=http://192.168.1.1:7890" \
            --build-arg "all_proxy=socks5://192.168.1.1:7891" \
            --progress=plain \
            -t $container .

sudo docker run \
        -v `pwd`:/home/openwrt/workdir \
        -v `pwd`/output:/home/openwrt/output \
        -v $container-cache:/home/openwrt/cache \
        -dit $container sh -c \
        "sudo chown openwrt:openwrt -R workdir output cache && \
        workdir/bin/build-openwrt.sh lienol-acrh17"

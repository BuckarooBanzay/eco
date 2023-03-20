ARG ENGINE_VERSION=5.6.1
FROM registry.gitlab.com/minetest/minetest/server:${ENGINE_VERSION}

USER root
RUN apk add git &&\
    mkdir -p /root/.minetest/worlds/world/worldmods/ &&\
    cd /root/.minetest/worlds/world/worldmods &&\
    git clone https://github.com/BuckarooBanzay/mtt &&\
    git clone https://github.com/BuckarooBanzay/mtzip &&\
    git clone https://github.com/BuckarooBanzay/mapblock_lib &&\
    git clone https://github.com/BuckarooBanzay/building_lib

ENTRYPOINT minetestserver --config /minetest.conf
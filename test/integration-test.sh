#!/bin/sh

CWD=$(dirname $0)
cd ${CWD}/../

CFG=/tmp/minetest.conf
MTDIR=/tmp/mt
WORLDDIR=${MTDIR}/worlds/world

cat <<EOF > ${CFG}
default_game = eco
EOF

mkdir -p ${WORLDDIR}
chmod 777 ${MTDIR} -R
docker run --rm -i \
	-v ${CFG}:/etc/minetest/minetest.conf:ro \
	-v ${MTDIR}:/var/lib/minetest/.minetest \
	-v $(pwd)/:/var/lib/minetest/.minetest/games/eco \
  -v $(pwd)/test/test_mod/:/var/lib/minetest/.minetest/worlds/world/worldmods/eco_test \
  --network host \
	registry.gitlab.com/minetest/minetest/server:5.2.0

test -f ${WORLDDIR}/integration_test.json && exit 0 || exit 1

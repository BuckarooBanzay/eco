#!/bin/sh

set -e
cd mods/eco_buildings && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_placement && luacheck .
cd ../eco_nodes && luacheck .
cd ../eco_test && luacheck .
cd ../building_lib && luacheck .

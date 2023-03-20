#!/bin/sh

set -e
cd mods/eco_buildings && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_nodes && luacheck .
cd ../building_lib_influence && luacheck .
cd ../building_lib && luacheck .
cd ../building_lib_overview && luacheck .
cd ../building_lib_interconnect && luacheck .
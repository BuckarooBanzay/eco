#!/bin/sh

cd mods/eco_buildings && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_placement && luacheck .
cd ../eco_stairsplus && luacheck .
cd ../eco_blocks && luacheck .
cd ../builtin_disable && luacheck .
cd ../building_lib && luacheck .
cd ../mapblock_lib && luacheck .

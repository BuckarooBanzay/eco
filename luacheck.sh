#!/bin/sh

cd mods/eco_buildings && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_placement && luacheck .
cd ../eco_nodes && luacheck .
cd ../building_lib && luacheck .

#!/bin/sh

set -e
cd mods/eco_buildings && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_nodes && luacheck .
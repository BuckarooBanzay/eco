#!/bin/sh

set -e
cd mods/eco_api && luacheck .
cd ../eco_editor && luacheck .
cd ../eco_mapgen && luacheck .
cd ../eco_nodes && luacheck .
cd ../eco_template && luacheck .

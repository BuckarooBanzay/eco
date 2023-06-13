# Eco

A game for minetest

Proof of concept Simutrans/SimCity/Network$A4 clone

State: **WIP**

![](https://github.com/BuckarooBanzay/eco/workflows/luacheck/badge.svg)

<img src="./menu/background.png"/>

# TODO

## Materials

Middle age:

* [ ] `stone`
* [ ] `gravel`
* [ ] `wood`
* [ ] `wood-planks`
* [ ] `bricks`
* [ ] `iron`
* [ ] `coal`
* [ ] `gold`
* [ ] `sand`

* [ ] `wheat`
* [ ] `flour`
* [ ] `bread`

Modern:

* [ ] `concrete`
* [ ] `metal`
* [ ] `glass`
* [ ] `copper`
* [ ] `oil`
* [ ] `plastic`

Future:

* [ ] ?

## Buildings

Middle age:

* [ ] Cobble-streets (needs `stone`)
* [ ] Town center 2x2
* [ ] Cobble/Wood buildings (shop, residnetial)
* [ ] Shops
* [ ] Stone quarry (produces `stone`)
* [ ] Forestry (produces `wood`)
* [ ] Charcoal factory (consumes `wood` -> produces `coal`)
* [ ] Sawmill (consumes `wood` -> produces `wood-planks`)
* [ ] Mine-shaft (iron, copper, etc) (produces `iron` / `copper`)
* [ ] Steel hut (consumes `iron` and `coal` -> produces `metal`)
* [ ] Agriculture (farm / surrounding crop-land) (produces `wheat`)
* [ ] ? Water supply
* [ ] ? Transportation

Modern:

* [ ] Concrete/Tar streets (`stone` + `gravel`)
* [ ] Town center 3x3
* [ ] Brick/Concrete buildings (shop, residential)
* [ ] ? Factories
* [ ] ? Power supply

Future:

* [ ] ? Space travel stuff
* [ ] ? Orbital platforms (energy, launch, research, production)
* [ ] ? Space elevator

Far future:

* [ ] ? Other planets/systems

## Technical

Near-term:

* [x] area-influence/environment (noisy, dirty, etc)
* [ ] placement restictions (money, materials?)
* [ ] power/liquid-distribution networks (`building_lib_interconnect`)
* [ ] building-timers (`building_lib`)
* [ ] building-updates depending on environment
* [ ] transport connections / routes (`building_lib_transport`)

Long-term:

* [ ] attack/defense buildings/units
* [ ] disasters (famine, earthquake, drought)

# Licenses

## Code

* MIT

--[[
9-sliced dynamic building

* Size: x=2, y=3, z=2
  * `(0,0,0)` = lower corner block, open to x+, z+
  * `(0,1,0)` = middle corner block, open to x+, z+
  * `(0,2,0)` = top corner block, open to x+, z+

  * `(1,0,0)` = lower edge block, open to z+
  * `(1,1,0)` = middle edge block, open to z+
  * `(1,2,0)` = top edge block, open to z+

  * `(1,0,1)` = lower inner block
  * `(1,1,1)` = middle inner block
  * `(1,2,1)` = top inner block

--]]



eco_api.register_placement("9slice_v1", {
    place = function(template, mapblock_pos, options)
        local catalog, err = mapblock_lib.get_catalog(template.zip_filename)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        assert(options.size)
        assert(options.size.x >= 2)
        assert(options.size.y >= 2)
        assert(options.size.z >= 2)

        local function rotate_option(angle)
          return {
            transform = {
              rotate = {
                angle = angle,
                axis = "y",
                disable_orientation = template.manifest.disable_orientation
              }
            }
          }
        end

        -- lower corners
        assert(catalog:deserialize(
          {x=0, y=0, z=0},
          mapblock_pos,
          rotate_option(0)
        ))
        assert(catalog:deserialize(
          {x=0, y=0, z=0},
          vector.add(mapblock_pos, {x=0,y=0,z=options.size.z-1}),
          rotate_option(90)
        ))
        assert(catalog:deserialize(
          {x=0, y=0, z=0},
          vector.add(mapblock_pos, {x=options.size.x-1,y=0,z=options.size.z-1}),
          rotate_option(180)
        ))
        assert(catalog:deserialize(
          {x=0, y=0, z=0},
          vector.add(mapblock_pos, {x=options.size.x-1,y=0,z=0}),
          rotate_option(270)
        ))

        -- upper corners
        assert(catalog:deserialize(
          {x=0, y=2, z=0},
          vector.add(mapblock_pos, {x=0,y=options.size.y-1,z=0}),
          rotate_option(0)
        ))
        assert(catalog:deserialize(
          {x=0, y=2, z=0},
          vector.add(mapblock_pos, {x=0,y=options.size.y-1,z=options.size.z-1}),
          rotate_option(90)
        ))
        assert(catalog:deserialize(
          {x=0, y=2, z=0},
          vector.add(mapblock_pos, {x=options.size.x-1,y=options.size.y-1,z=options.size.z-1}),
          rotate_option(180)
        ))
        assert(catalog:deserialize(
          {x=0, y=2, z=0},
          vector.add(mapblock_pos, {x=options.size.x-1,y=options.size.y-1,z=0}),
          rotate_option(270)
        ))

        -- middle corners
        for yo = 1,options.size.y-2 do
          assert(catalog:deserialize(
            {x=0, y=1, z=0},
            vector.add(mapblock_pos, {x=0,y=yo,z=0}),
            rotate_option(0)
          ))
          assert(catalog:deserialize(
            {x=0, y=1, z=0},
            vector.add(mapblock_pos, {x=0,y=yo,z=options.size.z-1}),
            rotate_option(90)
          ))
          assert(catalog:deserialize(
            {x=0, y=1, z=0},
            vector.add(mapblock_pos, {x=options.size.x-1,y=yo,z=options.size.z-1}),
            rotate_option(180)
          ))
          assert(catalog:deserialize(
            {x=0, y=1, z=0},
            vector.add(mapblock_pos, {x=options.size.x-1,y=yo,z=0}),
            rotate_option(270)
          ))
        end

        -- edges on z
        for xo = 1,options.size.x-2 do
          -- z-
          assert(catalog:deserialize(
            {x=1, y=0, z=0},
            vector.add(mapblock_pos, {x=xo,y=0,z=0}),
            rotate_option(0)
          ))
          assert(catalog:deserialize(
            {x=1, y=2, z=0},
            vector.add(mapblock_pos, {x=xo,y=options.size.y-1,z=0}),
            rotate_option(0)
          ))
          -- z+
          assert(catalog:deserialize(
            {x=1, y=0, z=0},
            vector.add(mapblock_pos, {x=xo,y=0,z=options.size.z-1}),
            rotate_option(180)
          ))
          assert(catalog:deserialize(
            {x=1, y=2, z=0},
            vector.add(mapblock_pos, {x=xo,y=options.size.y-1,z=options.size.z-1}),
            rotate_option(180)
          ))

          for yo = 1,options.size.y-2 do
            assert(catalog:deserialize(
              {x=1, y=1, z=0},
              vector.add(mapblock_pos, {x=xo,y=yo,z=0}),
              rotate_option(0)
            ))
            assert(catalog:deserialize(
              {x=1, y=1, z=0},
              vector.add(mapblock_pos, {x=xo,y=yo,z=options.size.z-1}),
              rotate_option(180)
            ))
          end
        end

        -- edges on x
        for zo = 1,options.size.z-2 do
          -- x-
          assert(catalog:deserialize(
            {x=1, y=0, z=0},
            vector.add(mapblock_pos, {x=0,y=0,z=zo}),
            rotate_option(90)
          ))
          assert(catalog:deserialize(
            {x=1, y=2, z=0},
            vector.add(mapblock_pos, {x=0,y=options.size.y-1,z=zo}),
            rotate_option(90)
          ))
          -- x+
          assert(catalog:deserialize(
            {x=1, y=0, z=0},
            vector.add(mapblock_pos, {x=options.size.x-1,y=0,z=zo}),
            rotate_option(270)
          ))
          assert(catalog:deserialize(
            {x=1, y=2, z=0},
            vector.add(mapblock_pos, {x=options.size.x-1,y=options.size.y-1,z=zo}),
            rotate_option(270)
          ))
          for yo = 1,options.size.y-2 do
            assert(catalog:deserialize(
              {x=1, y=1, z=0},
              vector.add(mapblock_pos, {x=0,y=yo,z=zo}),
              rotate_option(90)
            ))
            assert(catalog:deserialize(
              {x=1, y=1, z=0},
              vector.add(mapblock_pos, {x=options.size.x-1,y=yo,z=zo}),
              rotate_option(270)
            ))
          end
        end

        -- floor, ceiling, space (optional)
        for xo = 1,options.size.x-2 do
          for zo = 1,options.size.z-2 do
            assert(catalog:deserialize(
              {x=1, y=0, z=1},
              vector.add(mapblock_pos, {x=xo,y=0,z=zo})
            ))
            assert(catalog:deserialize(
              {x=1, y=2, z=1},
              vector.add(mapblock_pos, {x=xo,y=options.size.y-1,z=zo})
            ))

            if catalog:has_mapblock({x=1, y=1, z=1}) then
              for yo = 1,options.size.y-2 do
                assert(catalog:deserialize(
                  {x=1, y=1, z=1},
                  vector.add(mapblock_pos, {x=xo,y=yo,z=zo})
                ))
              end
            end
          end
        end

    end
})
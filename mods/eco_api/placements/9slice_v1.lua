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
    place = function(template, mapblock_pos)
        local catalog, err = mapblock_lib.get_catalog(template.zip_file_path)
        if err then
            -- something went wrong
            return true, "Error reading zip catalog: " .. err
        end

        -- TODO: error handling
        catalog:deserialize_all(mapblock_pos)
    end
})
-- Define crucible

local cbox = {
    {-0.5,  0.5, -0.5, -0.4, -0.4, -0.5}, -- North
    { 0.5,  0.5, -0.5,  0.4, -0.4, -0.5}, -- South
    {-0.5,  0.5, -0.5, -0.5, -0.4,  0.4}, -- East
    { 0.5,  0.5, -0.5,  0.5, -0.4,  0.4}, -- West
    {-0.5, -0.5, -0.5,  0.4, -0.4,  0.4}, -- Bottom
}

-- x0 y0   x0.5 y0   x1 y0
-- x0 y0.5 x0.5 y0.5 x1 y0.5
-- x0 y1   x0.5 y1   x1 y1

minetest.register_node("minetest_lava_crucible:lava_crucible", {
    description = "A crucible that is used by placing it over lava",
    is_ground_content = false,
    groups = {cracky = 1},
    tiles = {
        "crucible_top.png", -- up
        "crucible_bottom.png", -- down
        "crucible_side.png", -- right
        "crucible_side.png", -- left
        "crucible_side.png", -- back
        "crucible_side.png", -- front
    },
    node_box = {
        type = "fixed",
        fixed = cbox,
    },
})

minetest.register_abm({
	nodenames = {"minetest_lava_crucible:lava_crucible"},
	neighbors = {"default:lava_flowing", "default:lava_source"},
	interval = 10.0, -- Run every 60 seconds
    chance = 1,
    catch_up = true, -- Generate items that would have been generated while player was not present
    action = function(pos, node, active_object_count, active_object_count_wider)
        minetest.log("action", "[lava_crucible] Checking for stuff in the crucible")
        local crucible_contents = minetest.get_objects_inside_radius(pos, 0.5)

        -- No contents
        if #crucible_contents == 0 then
            return
        end

        local generated_items = {}

        -- Process each object
        for _, obj in pairs(crucible_contents) do
            if not obj then
                return
            end
            local luaentity = obj:get_luaentity()
            -- Log found object
            minetest.log("action", "[lava_crucible] Found object in crucible: " .. luaentity.itemstring)
            local itemstack = ItemStack(luaentity.itemstring)
            -- Check if the object is in the stone group
            if minetest.get_item_group(itemstack:get_name(), "stone") > 0 then
                -- Log that stone was found
                minetest.log("action", "[lava_crucible] Found stone in crucible")
                -- Add lava soil to generated items
                for i = 1, itemstack:get_count() do
                    -- Add the item to the generated items list
                    table.insert(generated_items, "minetest_lava_crucible:lava_soil")
                end
               -- remove the object
               obj:remove()
            end
	    end
        
        -- get position next to the crucible
        local above_pos = {x = pos.x, y = pos.y + 1, z = pos.z}

        -- If there are generated items, spawn them
        if #generated_items > 0 then
            -- Log the generated items
            minetest.log("action", "[lava_crucible] Generated lava soil")
            -- Spawn the items above the crucible
            for _, item in ipairs(generated_items) do
                minetest.add_item(above_pos, item)
            end
        end

        return true
    end,
})

-- Define the recipe to create a crucible:
-- clay_lump, none, clay_lump
-- clay_lump, metal_dust, clay_lump
-- none, clay_lump, none
minetest.register_craft({
    type = "shaped",
    output = "minetest_lava_crucible:lava_crucible 1",
    recipe = {
        {"default:clay_lump","","default:clay_lump"},
        {"default:clay_lump","group:mineral_dust","default:clay_lump"},
        {"","default:clay_lump",""}
    }
})

-- Define lava soil
minetest.register_node("minetest_lava_crucible:lava_soil", {
    description = "Lava Soil",
    is_ground_content = true,
    groups = { cracky = 1 },
    tiles = {
		{
			name = "lava_soil.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 6.0,
			},
		},
    },
})

-- Define the formspec for the pop-up when you open the crucible


-- Put cobble into the inventory for processing

-- Define the processing of rock into fertile soil
-- minetest.register_abm({

-- })

-- Define the random generation of mineral fragments




-- **** Example of getting image from another mod ****
-- local bucket_image = minetest.registered_craftitems["bucket:bucket_empty"].inventory_image

-- minetest.register_node("minetest_lava_crucible:crucible", {
--     description = "Lava Crucible",
--     tiles = {
--         bucket_image,
--         bucket_image,
--         bucket_image,
--         bucket_image,
--         bucket_image,
--         bucket_image
--     },
--     groups = {crumbly = 1, cracky = 1},
--     -- is_ground_content = false,
--     -- sunlight_propagates = false,
--     walkable = true,  -- If true, objects collide with node
--     pointable = true,  -- If true, can be pointed at
--     diggable = true,  -- If false, can never be dug
--     -- can_dig = function(pos)
--     --     return true
--     -- end,
--         -- Returns true if node can be dug, or false if not.
--         -- default: nil
    
-- })

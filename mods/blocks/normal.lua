local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local sound_dispatcher = get_game_sounds()

minetest.register_node(":stone", {
   drawtype = "normal",
   tiles = {
      "default_stone.png",
   },
   sounds = sound_dispatcher.stone_sounds(),
   groups = {
      stone = 1,
   },
})

minetest.register_node(":dirt", {
   drawtype = "normal",
   tiles = {
      "default_dirt.png",
   },
   sounds = sound_dispatcher.dirt_sounds(),
   groups = {
      soil = 1,
   },
})

minetest.register_node(":grass", {
   drawtype = "normal",
   tiles = {
      "default_grass.png",
      "default_dirt.png",
      "default_dirt.png^default_grass_side.png",
   },
   sounds = sound_dispatcher.grass_sounds(),
   groups = {
      soil = 1,
   },
   drop = "dirt",
})

minetest.register_node(":sand", {
   drawtype = "normal",
   tiles = {
      "default_sand.png",
   },
   sounds = sound_dispatcher.sand_sounds(),
   groups = {
      soil = 1,
   },
})

minetest.register_node(":gravel", {
   drawtype = "normal",
   tiles = {
      "default_gravel.png",
   },
   sounds = sound_dispatcher.gravel_sounds(),
   groups = {
      soil = 1,
   },
})

minetest.register_node(":oak_tree", {
   drawtype = "normal",
   tiles = {
      "default_tree_top.png",
      "default_tree_top.png",
      "default_tree.png",
   },
   sounds = sound_dispatcher.wood_sounds(),
   groups = {
      wooden = 1,
   },
})

minetest.register_node(":oak_leaves", {
   drawtype = "allfaces_optional",
   paramtype = "light",
   waving = 1,
   tiles = {
      "default_leaves.png",
   },
   sounds = sound_dispatcher.plant_sounds(),
   groups = {
      leafy = 1,
   },
   drop = "",
})

local dyes = {
   "black",
   "blue",
   "brown",
   "cyan",
   "dark_green",
   "dark_grey",
   "green",
   "grey",
   "magenta",
   "orange",
   "pink",
   "purple",
   "red",
   "violet",
   "white",
   "yellow",
}

for _, color in ipairs(dyes) do
   minetest.register_node(":wool_" .. color, {
      tiles = {
         "wool_" .. color .. ".png",
      },
      sounds = sound_dispatcher.wool_sounds(),
      groups = {
         wool = 1,
      },
   })
end

minetest.register_node(":glass", {
   drawtype = "glasslike_framed_optional",
   tiles = {
      "default_glass.png",
      "default_glass_detail.png",
   },
   use_texture_alpha = "clip",
   paramtype = "light",
   sunlight_propagates = true,
   is_ground_content = false,
   sounds = sound_dispatcher.glass_sounds(),
   groups = {
      glass = 1,
   },
   drop = "",
})

recipes = recipes or ({})
do
    local blockType = types.CraftingBlockType
    minetest.register_craft({type = CraftRecipeType.cooking, output = "glass", recipe = blockType.sand})
    minetest.register_craft({type = CraftRecipeType.cooking, output = "iron", recipe = "iron_ore"})
end

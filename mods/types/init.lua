types = types or ({})
do
    types.ToolType = ToolType or ({})
    types.ToolType.Pickaxe = "pickaxe"
    types.ToolType.Shovel = "shovel"
    types.ToolType.Axe = "axe"
    types.ToolType.Hoe = "hoe"
    types.ToolType.Sword = "sword"
    types.ToolType.Shears = "shears"
    types.BlockType = BlockType or ({})
    types.BlockType.break_instant = "break_instant"
    types.BlockType.soil = "soil"
    types.BlockType.wood = "wood"
    types.BlockType.leaf = "leaf"
    types.BlockType.stone = "stone"
    types.BlockType.metal = "metal"
    types.BlockType.glass = "glass"
    types.BlockType.wool = "wool"
    types.BlockType.planks = "planks"
    types.BlockType.tree = "tree"
    types.CraftingBlockType = CraftingBlockType or ({})
    types.CraftingBlockType.soil = "group:soil"
    types.CraftingBlockType.wood = "group:wood"
    types.CraftingBlockType.leaf = "group:leaf"
    types.CraftingBlockType.stone = "group:stone"
    types.CraftingBlockType.metal = "group:metal"
    types.CraftingBlockType.glass = "group:glass"
    types.CraftingBlockType.wool = "group:wool"
    types.CraftingBlockType.planks = "group:planks"
    types.CraftingBlockType.tree = "group:tree"
end

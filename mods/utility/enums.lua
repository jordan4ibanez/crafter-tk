EntityVisual = EntityVisual or ({})
EntityVisual.cube = "cube"
EntityVisual.sprite = "sprite"
EntityVisual.upright_sprite = "upright_sprite"
EntityVisual.mesh = "mesh"
EntityVisual.wielditem = "wielditem"
EntityVisual.item = "item"
SchematicRotation = SchematicRotation or ({})
SchematicRotation.zero = "0"
SchematicRotation.ninety = "90"
SchematicRotation.oneEighty = "180"
SchematicRotation.twoSeventy = "270"
SchematicRotation.random = "random"
SchematicPlacementFlag = SchematicPlacementFlag or ({})
SchematicPlacementFlag.place_center_x = "place_center_x"
SchematicPlacementFlag.place_center_y = "place_center_y"
SchematicPlacementFlag.place_center_z = "place_center_z"
SchematicFormat = SchematicFormat or ({})
SchematicFormat.mts = "mts"
SchematicFormat.lua = "lua"
SchematicSerializationOption = SchematicSerializationOption or ({})
SchematicSerializationOption.lua_use_comments = "lua_use_comments"
SchematicSerializationOption.lua_num_indent_spaces = "lua_num_indent_spaces"
SchematicReadOptionYSliceOption = SchematicReadOptionYSliceOption or ({})
SchematicReadOptionYSliceOption.none = "none"
SchematicReadOptionYSliceOption.low = "low"
SchematicReadOptionYSliceOption.all = "all"
HTTPRequestMethod = HTTPRequestMethod or ({})
HTTPRequestMethod.GET = "GET"
HTTPRequestMethod.POST = "POST"
HTTPRequestMethod.PUT = "PUT"
HTTPRequestMethod.DELETE = "DELETE"
OreType = OreType or ({})
OreType.scatter = "scatter"
OreType.sheet = "sheet"
OreType.puff = "puff"
OreType.blob = "blob"
OreType.vein = "vein"
OreType.stratum = "stratum"
OreFlags = OreFlags or ({})
OreFlags.puff_cliffs = "puff_cliffs"
OreFlags.puff_additive_composition = "puff_additive_composition"
NoiseFlags = NoiseFlags or ({})
NoiseFlags.defaults = "defaults"
NoiseFlags.eased = "eased"
NoiseFlags.absvalue = "absvalue"
DecorationType = DecorationType or ({})
DecorationType.simple = "simple"
DecorationType.schematic = "schematic"
DecorationFlags = DecorationFlags or ({})
DecorationFlags.liquid_surface = "liquid_surface"
DecorationFlags.force_placement = "force_placement"
DecorationFlags.all_floors = "all_floors"
DecorationFlags.all_ceilings = "all_ceilings"
DecorationFlags.place_center_x = "place_center_x"
DecorationFlags.place_center_y = "place_center_y"
DecorationFlags.place_center_z = "place_center_z"
ParamType1 = ParamType1 or ({})
ParamType1.light = "light"
ParamType1.none = "none"
ParamType2 = ParamType2 or ({})
ParamType2.flowingliquid = "flowingliquid"
ParamType2.wallmounted = "wallmounted"
ParamType2.facedir = "facedir"
ParamType2.fourdir = "4dir"
ParamType2.leveled = "leveled"
ParamType2.degrotate = "degrotate"
ParamType2.meshoptions = "meshoptions"
ParamType2.color = "color"
ParamType2.colorfacedir = "colorfacedir"
ParamType2.color4dir = "color4dir"
ParamType2.colorwallmounted = "colorwallmounted"
ParamType2.glasslikeliquidlevel = "glasslikeliquidlevel"
ParamType2.colordegrotate = "colordegrotate"
drawtype = drawtype or ({})
drawtype.normal = "normal"
drawtype.airlike = "airlike"
drawtype.liquid = "liquid"
drawtype.flowingliquid = "flowingliquid"
drawtype.glasslike = "glasslike"
drawtype.glasslike_framed = "glasslike_framed"
drawtype.glasslike_framed_optional = "glasslike_framed_optional"
drawtype.allfaces = "allfaces"
drawtype.allfaces_optional = "allfaces_optional"
drawtype.torchlike = "torchlike"
drawtype.signlike = "signlike"
drawtype.plantlike = "plantlike"
drawtype.firelike = "firelike"
drawtype.fencelike = "fencelike"
drawtype.raillike = "raillike"
drawtype.nodebox = "nodebox"
drawtype.mesh = "mesh"
drawtype.plantlike_rooted = "plantlike_rooted"
nodeboxtype = nodeboxtype or ({})
nodeboxtype.regular = "regular"
nodeboxtype.fixed = "fixed"
nodeboxtype.wallmounted = "wallmounted"
nodeboxtype.connected = "connected"
LogLevel = LogLevel or ({})
LogLevel.none = "none"
LogLevel.error = "error"
LogLevel.warning = "warning"
LogLevel.action = "action"
LogLevel.info = "info"
LogLevel.verbose = "verbose"
TextureAlpha = TextureAlpha or ({})
TextureAlpha.opaque = "opaque"
TextureAlpha.clip = "clip"
TextureAlpha.blend = "blend"
LiquidType = LiquidType or ({})
LiquidType.none = "none"
LiquidType.source = "source"
LiquidType.flowing = "flowing"
NodeBoxConnections = NodeBoxConnections or ({})
NodeBoxConnections.top = "top"
NodeBoxConnections.bottom = "bottom"
NodeBoxConnections.front = "front"
NodeBoxConnections.left = "left"
NodeBoxConnections.back = "back"
NodeBoxConnections.right = "right"
CraftRecipeType = CraftRecipeType or ({})
CraftRecipeType.shapeless = "shapeless"
CraftRecipeType.toolrepair = "toolrepair"
CraftRecipeType.cooking = "cooking"
CraftRecipeType.fuel = "fuel"
HPChangeReasonType = HPChangeReasonType or ({})
HPChangeReasonType.set_hp = "set_hp"
HPChangeReasonType.punch = "punch"
HPChangeReasonType.fall = "fall"
HPChangeReasonType.node_damage = "node_damage"
HPChangeReasonType.drown = "drown"
HPChangeReasonType.respawn = "respawn"
CheatType = CheatType or ({})
CheatType.moved_too_fast = "moved_too_fast"
CheatType.interacted_too_far = "interacted_too_far"
CheatType.interacted_with_self = "interacted_with_self"
CheatType.interacted_while_dead = "interacted_while_dead"
CheatType.finished_unknown_dig = "finished_unknown_dig"
CheatType.dug_unbreakable = "dug_unbreakable"
CheatType.dug_too_fast = "dug_too_fast"
ClearObjectsOptions = ClearObjectsOptions or ({})
ClearObjectsOptions.full = "full"
ClearObjectsOptions.quick = "quick"
GenNotifyFlags = GenNotifyFlags or ({})
GenNotifyFlags.dungeon = "dungeon"
GenNotifyFlags.temple = "temple"
GenNotifyFlags.cave_begin = "cave_begin"
GenNotifyFlags.cave_end = "cave_end"
GenNotifyFlags.large_cave_begin = "large_cave_begin"
GenNotifyFlags.large_cave_end = "large_cave_end"
GenNotifyFlags.decoration = "decoration"
SearchAlgorithm = SearchAlgorithm or ({})
SearchAlgorithm.aStarNoprefetch = "A*_noprefetch"
SearchAlgorithm.aStar = "A*"
SearchAlgorithm.dijkstra = "Dijkstra"
SkyParametersType = SkyParametersType or ({})
SkyParametersType.regular = "regular"
SkyParametersType.skybox = "skybox"
SkyParametersType.plain = "plain"
SkyParametersFogTintType = SkyParametersFogTintType or ({})
SkyParametersFogTintType.custom = "custom"
SkyParametersFogTintType.default = "default"
MinimapType = MinimapType or ({})
MinimapType.off = "off"
MinimapType.surface = "surface"
MinimapType.radar = "radar"
MinimapType.texture = "texture"
HudElementType = HudElementType or ({})
HudElementType.image = "image"
HudElementType.text = "text"
HudElementType.statbar = "statbar"
HudElementType.inventory = "inventory"
HudElementType.waypoint = "waypoint"
HudElementType.image_waypoint = "image_waypoint"
HudElementType.compass = "compass"
HudElementType.minimap = "minimap"
HudReplaceBuiltinOption = HudReplaceBuiltinOption or ({})
HudReplaceBuiltinOption.breath = "breath"
HudReplaceBuiltinOption.health = "health"
ParseRelativeNumberArgument = ParseRelativeNumberArgument or ({})
ParseRelativeNumberArgument.number = "<number>"
ParseRelativeNumberArgument.relativeToPlus = "~<number>"
ParseRelativeNumberArgument.relativeTo = "~"
CompressionMethod = CompressionMethod or ({})
CompressionMethod.deflate = "deflate"
CompressionMethod.zstd = "zstd"
RotateAndPlaceOrientationFlag = RotateAndPlaceOrientationFlag or ({})
RotateAndPlaceOrientationFlag.invert_wall = "invert_wall"
RotateAndPlaceOrientationFlag.force_wall = "force_wall"
RotateAndPlaceOrientationFlag.force_ceiling = "force_ceiling"
RotateAndPlaceOrientationFlag.force_floor = "force_floor"
RotateAndPlaceOrientationFlag.force_facedir = "force_facedir"
BlockStatusCondition = BlockStatusCondition or ({})
BlockStatusCondition.unknown = "unknown"
BlockStatusCondition.emerging = "emerging"
BlockStatusCondition.loaded = "loaded"
BlockStatusCondition.active = "active"
TileAnimationType = TileAnimationType or ({})
TileAnimationType.vertical_frames = "vertical_frames"
TileAnimationType.sheed_2d = "sheed_2d"
ParticleSpawnerTweenStyle = ParticleSpawnerTweenStyle or ({})
ParticleSpawnerTweenStyle.fwd = "fwd"
ParticleSpawnerTweenStyle.rev = "rev"
ParticleSpawnerTweenStyle.pulse = "pulse"
ParticleSpawnerTweenStyle.flicker = "flicker"
ParticleSpawnerTextureBlend = ParticleSpawnerTextureBlend or ({})
ParticleSpawnerTextureBlend.alpha = "alpha"
ParticleSpawnerTextureBlend.add = "add"
ParticleSpawnerTextureBlend.screen = "screen"
ParticleSpawnerTextureBlend.sub = "sub"
ParticleSpawnerAttractionType = ParticleSpawnerAttractionType or ({})
ParticleSpawnerAttractionType.none = "none"
ParticleSpawnerAttractionType.point = "point"
ParticleSpawnerAttractionType.line = "line"
ParticleSpawnerAttractionType.plane = "plane"
AreaStoreType = AreaStoreType or ({})
AreaStoreType.libSpatial = "LibSpatial"
TexturePoolComponentFade = TexturePoolComponentFade or ({})
TexturePoolComponentFade["in"] = "in"
TexturePoolComponentFade.out = "out"

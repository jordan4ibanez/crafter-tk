namespace blocks {


  const textureSize = 16
  const MAIN_INVENTORY_SIZE = player.MAIN_INVENTORY_SIZE
  const create = vector.create2d
  const generate = formSpec.generate
  const FormSpec = formSpec.FormSpec
  const BackGround = formSpec.Background
  const Image = formSpec.Image
  const BGColor = formSpec.BGColor
  const List = formSpec.List
  const ListColors = formSpec.ListColors
  const ListRing = formSpec.ListRing

  const color = utility.color
  const colorScalar = utility.colorScalar
  const colorRGB = utility.colorRGB
  const vec3ToString = utility.vec3ToString

  //? Functionality

  function turnTexture(input: string): string {
    return input + "^[transformR270"
  }

  function chopTexture(input: string, percent: number): string {
    return "^[lowpart:" + percent + ":" + input
  }

  function turnOn(position: Vec3) {
    minetest.swap_node(position, {name: "furnace_active"})
  }

  function turnOff(position:Vec3) {
    minetest.swap_node(position, {name: "furnace"})
  }

  function resolveSmeltingResults(inputList: ItemStackObject[]): [CraftResultObject, CraftRecipeCheckDefinition, boolean] {  
    const [cooked, afterCooked] = minetest.get_craft_result({
      method: CraftCheckType.cooking,
      width: 1,
      items: inputList
    })
    const cookable = (cooked.time != 0)
    return [cooked, afterCooked, cookable]
  }

  function smeltLogic(
    fuelTime: number,
    accumulator: number,
    cookable: boolean,
    inputTime: number,
    // Refs
    cooked: CraftResultObject,
    afterCooked: CraftRecipeCheckDefinition,
    inventory: InvRef,
  ): [boolean, boolean, number] {

    let update = false
    let outputFull = false

    // The furnace is active and has enough fuel.
    fuelTime += accumulator

    // If there is a cookable item then check if it not ready.
    if (!cookable) {
      return [update, outputFull, fuelTime]
    }
      
    inputTime += accumulator

    if (inputTime >= cooked.time) {

      // Place result in output list if possible.
      if (inventory.room_for_item("output", cooked.item)) {
        inventory.add_item("output", cooked.item)
        inventory.set_stack("input", 1, afterCooked.items[1])
        inputTime -= cooked.time
        update = true
        print("Play melt sound here...")
      } else {
        outputFull = false
      }
    } else {

      // Item could not be cooked, probably missing fuel.
      update = true
    }

    return [update, outputFull, fuelTime]
  }

  function getNewFuel(fuelList: ItemStackObject[]): [CraftResultObject, CraftRecipeCheckDefinition] {
    return minetest.get_craft_result({
      method: CraftCheckType.fuel,
      width: 1,
      items: fuelList
    })
  }

  function fuelCheck(afterFuel: CraftRecipeCheckDefinition): CraftResultObject {
    // Prevent blocking of fuel inventory. (For automation mods)
    const [isFuel, _] = minetest.get_craft_result({
      method: CraftCheckType.fuel,
      width: 1,
      items: [
        afterFuel.items[1] //! FIXME: Might need to_string()
      ]
    })
    return isFuel
  }

  function checkFuelTime(inventory: InvRef, fuel: CraftResultObject, isFuel: CraftResultObject, afterFuel: CraftRecipeCheckDefinition) {
    if (isFuel.time == 0) {
      table.insert(fuel.replacements, afterFuel.items[1])
      inventory.set_stack("fuel", 1, "")
    } else {
      // Take fuel from fuel list.
      inventory.set_stack("fuel", 1, afterFuel.items[1])
    }
  }

  function processFuelReplacements(
    inventory: InvRef,
    fuel: CraftResultObject,
    position: Vec3,
    ): void {
    // Put replacements in output list or drop them on the furnace.
    const replacements = fuel.replacements
    if (replacements[1]) {
      const leftOver = inventory.add_item("output", replacements[1])
      if (!leftOver.is_empty()) {
        const above = vector.create(position.x, position.y + 1, position.z)
        const dropPosition = minetest.find_node_near(above, 1, ["air"]) || above
        minetest.item_drop(replacements[1], null, dropPosition)
      }
    }
  }

  function finalizeFuelProcessing(
    fuelTotalTime: number,
    fuelTime: number,
    // Refs
    fuel: CraftResultObject,
    update: boolean
  ): [boolean, number] {
    update = true
    fuelTotalTime = fuel.time + (fuelTotalTime - fuelTime)
    return [update, fuelTotalTime]
  }

  function fuelLogic(
    update: boolean,
    cookable: boolean,
    fuelTotalTime: number,
    fuelTime: number,
    inputTime: number,
    // Refs
    fuel: CraftResultObject | undefined,
    fuelList: ItemStackObject[],
    inventory: InvRef,
    position: Vec3
  ): [boolean, boolean, number, number, number] {
    // Furnace ran out of fuel.
    if (cookable) {
      // We need to get new fuel.
      let afterFuel: CraftRecipeCheckDefinition
      [fuel, afterFuel] = getNewFuel(fuelList)
      if (fuel.time == 0) {
        // No valid fuel in the fuel list.
        fuelTotalTime = 0
      } else {
        const isFuel = fuelCheck(afterFuel)
        checkFuelTime(inventory, fuel, isFuel, afterFuel)
        processFuelReplacements(inventory, fuel, position);
        [update, fuelTotalTime] = finalizeFuelProcessing(fuelTotalTime, fuelTime, fuel, update)
      }
    } else {
      // We don't need to get new fuel since there is no cookable item.
      fuelTotalTime = 0
      inputTime = 0
    }
    fuelTime = 0

    return [update, cookable, fuelTotalTime, fuelTime, inputTime]
  }

  function accumulate(elapsed: number, fuelTotalTime: number, fuelTime: number, cookable: boolean, cooked: CraftResultObject, inputTime: number): number {

    let accumulator = math.min(elapsed, fuelTotalTime - fuelTime)

    // Fuel lasts long enough, adjust accumulator to cooking duration.
    if (cookable) {
      accumulator = math.min(accumulator, cooked.time - inputTime)
    }

    return accumulator
  }

  function runLogic(
    update: boolean,
    cookable: boolean,
    outputFull: boolean,
    timerElapsed: number,
    elapsed: number,
    fuelTime: number,
    fuelTotalTime: number,
    inputTime: number,
    // Refs
    cooked: CraftResultObject | undefined,
    inventory: InvRef,
    inputList: ItemStackObject[] | undefined,
    fuelList: ItemStackObject[] | undefined,
    fuel: CraftResultObject | undefined,
    position: Vec3
    ): [boolean, boolean, boolean, number, number, number, number, number] {
    if (timerElapsed > 0 && update) {

      update = false

      //todo: check if we have to get lists every time
      inputList = inventory.get_list("input")
      fuelList = inventory.get_list("fuel");

      //? Smelting

      let afterCooked: CraftRecipeCheckDefinition

      // Check if we have smeltable items.
      [cooked, afterCooked, cookable] = resolveSmeltingResults(inputList)

      const accumulator = accumulate(elapsed, fuelTotalTime, fuelTime, cookable, cooked, inputTime)

      // Check if we have enough fuel to burn.
      if (fuelTime < fuelTotalTime) {
        [update, outputFull, fuelTime] = smeltLogic(fuelTime, accumulator, cookable, inputTime, cooked, afterCooked, inventory)
      } else {
        [update, cookable, fuelTotalTime, fuelTime, inputTime] = fuelLogic(update, cookable, fuelTotalTime, fuelTime, inputTime, fuel, fuelList, inventory, position)
      }

      elapsed -= accumulator

      return runLogic(update, cookable, outputFull, timerElapsed, elapsed, fuelTime, fuelTotalTime, inputTime, cooked, inventory, inputList, fuelList, fuel, position)
    }
    return [update, cookable, outputFull, timerElapsed, elapsed, fuelTime, fuelTotalTime, inputTime]
  }

  function think(position: Vec3, elapsed: number, justConstructed?: boolean): boolean {

    const currentBlock = minetest.get_node_or_nil(position)
    if (!currentBlock || currentBlock.name == "ignore") {
      print("Furnace: Error, tried to do work on null object.")
      return false
    }
    const meta = minetest.get_meta(position)
    const inventory = meta.get_inventory()

    if (justConstructed) {
      print("Hey I'm new at " + vec3ToString(position))
      inventory.set_size("input", 1)
      inventory.set_size("fuel", 1)
      inventory.set_size("output", 1)
    }

    const currentlyActive = (currentBlock.name == "furnace_active")

    let fuelTime = meta.get_float("fuelTime") || 0
    let inputTime = meta.get_float("inputTime") || 0
    let fuelTotalTime = meta.get_float("fuelTotalTime") || 0
    let timerElapsed = meta.get_int("timerElapsed") || 0

    meta.set_int("timerElapsed", timerElapsed + 1)
    
    print(`thinking at ${vec3ToString(position)}...`)

    let inputList: ItemStackObject[] | undefined
    let fuelList: ItemStackObject[] | undefined
    let outputFull = false


    let cookable: boolean = false
    let cooked: CraftResultObject | undefined
    let fuel: CraftResultObject | undefined

    let update = true;

    [update, cookable, outputFull, timerElapsed, elapsed, fuelTime, fuelTotalTime, inputTime] = 
    runLogic(update, cookable, outputFull,timerElapsed, elapsed, fuelTime, fuelTotalTime, inputTime, cooked, inventory, inputList, fuelList, fuel, position);

    if (fuel && fuelTotalTime > fuel.time) {
      fuelTotalTime = fuel.time
    }

    if (inputList && inputList[1].is_empty()) {
      inputTime = 0
    }

    // Update formspec and node.

    let itemPercent = 0

    if (cookable && cooked) {
      itemPercent = math.floor(inputTime / cooked.time * 100)
    }

    let active = false
    let result = false

    const fuelPercent = 100 - math.floor((fuelTime / fuelTotalTime) * 100)

    // Furnace is currently active.
    if (fuelTotalTime != 0) {
      active = true
      
      if (!currentlyActive) {
        turnOn(position)
        print("sound handler goes here")
      }
    // Furnace is currently off.
    } else {
      if (currentlyActive) {
        turnOff(position)
      }
      minetest.get_node_timer(position).stop()
      meta.set_int("timerElapsed", 0)
      
      print("sound handler stopper goes here")
    }

    print("gui_furnace_arrow_bg.png" + chopTexture("gui_furnace_arrow_fg.png", itemPercent) + "]")

    // Now update the formspec.
    const furnaceInventory: string = generate(new FormSpec({
      size: create(12,12),
      elements: [
        //! Nice background colors.
        new BGColor({
          bgColor: colorScalar(85),
          fullScreen: "both",
          fullScreenbgColor: colorScalar(0,40)
        }),
        //! Make these lists look nice as well.
        new ListColors({
          slotBGHover: colorScalar(70),
          slotBGNormal: colorScalar(55),
          slotBorder: colorScalar(0),
          toolTipBGColor: colorRGB(123,104,238),
          toolTipFontColor: colorScalar(100)
        }),
        //! Flame.
        new Image({
          position: create(
            3,
            2.5
          ),
          size: create(
            1,
            1
          ),
          texture: "default_furnace_fire_bg.png" + chopTexture("default_furnace_fire_fg.png", fuelPercent) + "]"
        }),
        //! Arrow.
        new Image({
          position: create(
            5.5,
            2.5
          ),
          size: create(
            1,
            1
          ),
          texture: turnTexture("gui_furnace_arrow_bg.png" + chopTexture("gui_furnace_arrow_fg.png", itemPercent)) + "]"
        }),
        //! Fuel.
        new List({
          location: "context",
          listName: "fuel",
          position: create(
            3,
            4
          ),
          size: create(
            1,
            1
          ),
          startingIndex: 0
        }),
        //! Input.
        new List({
          location: "context",
          listName: "input",
          position: create(
            3,
            1
          ),
          size: create(
            1,
            1
          ),
          startingIndex: 0
        }),
        //! Output.
        new List({
          location: "context",
          listName: "output",
          position: create(
            8,
            2.5
          ),
          size: create(
            1,
            1
          ),
          startingIndex: 0
        }),
        //! Hot bar.
        new List({
          location: "current_player",
          listName: "main",
          position: create(
            0.5,
            6.5
          ),
          size: create(
            MAIN_INVENTORY_SIZE.x,
            1
          ),
          startingIndex: 0
        }),
        //! Main inventory.
        new List({
          location: "current_player",
          listName: "main",
          position: create(
            0.5,
            8
          ),
          size: create(
            MAIN_INVENTORY_SIZE.x,
            MAIN_INVENTORY_SIZE.y - 1
          ),
          startingIndex: MAIN_INVENTORY_SIZE.x
        }),
        //! List Rings.
        new ListRing({
          location: "current_player",
          listName: "main"
        }),
        new ListRing({
          location: "context",
          listName: "fuel"
        }),
        new ListRing({
          location: "current_player",
          listName: "main"
        }),
        new ListRing({
          location: "context",
          listName: "input"
        })

      ]
    }))

    // Set meta values.
    meta.set_float("fuelTotalTime", fuelTotalTime)
    meta.set_float("fuelTime", fuelTime)
    meta.set_float("inputtime", inputTime)
    meta.set_string("formspec", furnaceInventory)
    return result

  }

  //! This should probably be a utility function.
  function pixel(inputPixel: number): number {
    return (inputPixel / textureSize) - 0.5
  }

  function startTimer(position: Vec3) {
    minetest.get_node_timer(position).start(1)
  }


  //? Visuals

  const furnaceNodeBox: NodeBox = {
    type: Nodeboxtype.fixed,
    fixed:[
      [ // Left slice.
        pixel(0),pixel(0),pixel(0),
        pixel(2),pixel(16),pixel(16)
      ],
      [ // Right slice.
        pixel(14),pixel(0),pixel(0),
        pixel(16),pixel(16),pixel(16)
      ],
      [ // Top slice.
        pixel(0),pixel(13),pixel(0),
        pixel(16),pixel(16),pixel(16)
      ],
      [ // Center slice.
        pixel(0),pixel(6),pixel(0),
        pixel(16),pixel(9),pixel(16)
      ],
      [ // Bottom slice.
        pixel(0),pixel(0),pixel(0),
        pixel(16),pixel(1),pixel(16)
      ],
      [ // Inner core.
        pixel(0),pixel(0),pixel(2),
        pixel(16),pixel(16),pixel(16)
      ],
    ] 
  }

  const furnaceSelectionBox: NodeBox = {
    type: Nodeboxtype.fixed,
    fixed: [
      [pixel(0),pixel(0),pixel(0),pixel(16),pixel(16),pixel(16)]
    ]
  }

  //? Implementation

  minetest.register_node(":furnace", {
    drawtype: Drawtype.nodebox,
    paramtype2: ParamType2.facedir,
    is_ground_content: false,
    node_box: furnaceNodeBox,
    selection_box: furnaceSelectionBox,
    groups: {
      stone: 1
    },
    sounds: sounds.stone(),
    tiles: [
      "default_furnace_top.png",
      "default_furnace_bottom.png",
      "default_furnace_side.png",
      "default_furnace_side.png",
      "default_furnace_side.png",
      "default_furnace_front.png"
    ],
    on_timer: think,
    on_punch: function(pos: Vec3){
      think(pos, 0, true)
    },
    on_construct(position: Vec3) {
      // print(dump(position))
      think(position, 0, true)
    },
    on_metadata_inventory_move: startTimer,
    on_metadata_inventory_put: startTimer,
    on_metadata_inventory_take: startTimer
  })

  minetest.register_node(":furnace_active", {
    drawtype: Drawtype.nodebox,
    paramtype2: ParamType2.facedir,
    is_ground_content: false,
    node_box: furnaceNodeBox,
    selection_box: furnaceSelectionBox,
    groups: {
      stone: 1
    },
    sounds: sounds.stone(),
    tiles: [
      "default_furnace_top.png",
      "default_furnace_bottom.png",
      "default_furnace_side.png",
      "default_furnace_side.png",
      "default_furnace_side.png",
      "default_furnace_front_active.png"
    ],
    on_timer: think,
    on_punch: function(pos: Vec3){
      think(pos, 0, true)
    },
    on_construct(position: Vec3) {
      think(position, 0, true)
    },
    on_metadata_inventory_move: startTimer,
    on_metadata_inventory_put: startTimer,
    on_metadata_inventory_take: startTimer
  })

}
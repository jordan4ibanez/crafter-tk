

println(
"Loading sounds.\n",
"Credits:\n",

"BEGIN STEP:",
"grass_step_(1-6): https://freesound.org/people/Yuval/sounds/189640/ CC0",
"CC BY 4.0 can be read here: https://creativecommons.org/licenses/by/4.0/",
"grass_step_7: https://freesound.org/people/spycrah/sounds/535220/ CC BY 4.0",
"grass_step_8: https://freesound.org/people/spycrah/sounds/535222/ CC BY 4.0",
"CC BY 3.0 can be read here: https://creativecommons.org/licenses/by/3.0/",
"dirt_step_(1-4): https://freesound.org/people/kMoon/sounds/167157/ CC BY 3.0",
"sand_step_(1-8): https://freesound.org/people/worthahep88/sounds/319208/ CC0",
"gravel_step_(1-6): https://freesound.org/people/SpliceSound/sounds/218304/ CC0",
"wool_step_(1-6): https://freesound.org/people/Adielees9/sounds/331167/ CC0",
"leaves_step_(1-6): https://freesound.org/people/Nox_Sound/sounds/496420/ CC0",
"wood_step_(1-6): https://freesound.org/people/florianreichelt/sounds/459970/ CC0",
"stone_step_(1-6): https://freesound.org/people/PeteBarry/sounds/647390/ CC BY 4.0",
"metal_step_(1-6): https://freesound.org/people/Eelke/sounds/462599/ CC BY 4.0",
"glass_step_(1-6): https://freesound.org/people/arseniiv/sounds/614846/ CC0",
"snow_step_(1-6): https://freesound.org/people/crunchymaniac/sounds/696281/ CC0",

"BEGIN DIG:",
"wool_dig_(1-4): https://freesound.org/people/krnash/sounds/389799/ CC0",
"dirt_dig_(1-6): https://freesound.org/people/monte32/sounds/353799/ CC0",
"wood_dig_(1-5): https://freesound.org/people/monte32/sounds/405114/ CC0",
"snow_dig(1-2): https://freesound.org/people/Nox_Sound/sounds/555307/ CC0",
"snow_dig_3: https://freesound.org/people/OwlStorm/sounds/320144/ CC0",
"snow_dig_4: https://freesound.org/people/martian/sounds/19291/ CC0",
"sand_dig_(1-6): https://freesound.org/people/HenKonen/sounds/682127/ CC0",
"gravel_dig_(1-6): https://freesound.org/people/PeteBarry/sounds/647395/ CC BY 4.0",
"stone_dig_1: https://freesound.org/people/nicholasdaryl/sounds/563468/ CC0",
"stone_dig_2: https://freesound.org/people/nicholasdaryl/sounds/563470/ CC0",
"stone_dig_3: https://freesound.org/people/nicholasdaryl/sounds/563471/ CC0",
"stone_dig_4: https://freesound.org/people/nicholasdaryl/sounds/563473/ CC0",
"stone_dig_5: https://freesound.org/people/nicholasdaryl/sounds/563477/ CC0",
"stone_dig_6: https://freesound.org/people/nicholasdaryl/sounds/563476/ CC0",
"grass_dig_(1-6): https://freesound.org/people/Motion_S/sounds/221756/ CC BY 3.0",
"metal_dig_1: https://freesound.org/people/timgormly/sounds/170958/ CC BY 3.0",
"metal_dig_2: https://freesound.org/people/timgormly/sounds/170959/ CC BY 3.0")

































sounds = {}

function sounds.grass_sounds(spec)
   if (spec == nil) then
      spec = {}
   end
   spec.footstep = spec.footstep or { name = "grass_dig", gain = 1.0 }
   spec.dig = spec.dig or { name = "grass_step", gain = 1.0 }
   spec.dug = spec.dug or { name = "dirt_step", gain = 1.25 }
   spec.place = spec.place or { name = "dirt_step", gain = 1.0 }
   return spec
end

function get_game_sounds() return sounds end

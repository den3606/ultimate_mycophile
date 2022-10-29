dofile_once("mods/ultimate_mycophile/files/scripts/lib/utilities.lua")
Coil = dofile_once("mods/ultimate_mycophile/files/scripts/lib/coil/coil.lua")
print("ultimate_mycophile load")

ModLuaFileAppend("mods/ultimate_mycophile/files/scripts/fungal_shift.lua", "mods/ultimate_mycophile/files/scripts/limit_break_of_fungal_shift.lua")

function OnModPreInit()
  print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
  print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
  print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
  local numberOfShiftTimes = tonumber(ModSettingGet('ultimate_mycophile.number_of_fungal_shifts') or 19)
  local shiftSpan = tonumber(ModSettingGet('ultimate_mycophile.shift_span') or 60)
  dofile("mods/ultimate_mycophile/files/scripts/fungal_shift.lua")
  Coil.add(function()
    Coil.wait(60)
    for i = 1, numberOfShiftTimes do
      local x, y = EntityGetTransform(player_entity)
      fungal_shift(player_entity, x, y, true)
      Coil.wait(shiftSpan)
    end
  end)
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
  GamePrint("OnWorldInitialized() " .. tostring(GameGetFrameNum()))
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
  Coil.update(1)
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
end

function OnMagicNumbersAndWorldSeedInitialized() -- this is the last point where the Mod* API is available. after this materials.xml will be loaded.
  print("===================================== random " .. tostring(x))
end

print("ultimate_mycophile loaded")

print("ultimate_mycophile load")

dofile_once("mods/ultimate_mycophile/files/scripts/lib/utilities.lua")
Coil = dofile_once("mods/ultimate_mycophile/files/scripts/lib/coil/coil.lua")

ModLuaFileAppend("mods/ultimate_mycophile/files/scripts/fungal_shift.lua", "mods/ultimate_mycophile/files/scripts/limit_break_of_fungal_shift.lua")

function OnPlayerSpawned(player_entity) -- This runs when player entity has been created
  local numberOfShiftTimes = tonumber(ModSettingGet('ultimate_mycophile.NUMBER_OF_FUNGAL_SHIFTS') or 19)
  local shiftSpan = tonumber(ModSettingGet('ultimate_mycophile.SHIFT_SPAN') or 60)
  dofile("mods/ultimate_mycophile/files/scripts/fungal_shift.lua")
  Coil.add(function()
    Coil.wait(60)
    for i = 1, numberOfShiftTimes do
      player_entity = GetPlayerEntity()
      if player_entity == nil then
        break
      end
      local x, y = EntityGetTransform(player_entity)
      fungal_shift(player_entity, x, y, true)
      Coil.wait(shiftSpan)
    end
  end)
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
  Coil.update(1)
end

print("ultimate_mycophile loaded")

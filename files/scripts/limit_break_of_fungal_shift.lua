dofile_once("data/scripts/lib/utilities.lua")

function fungal_shift(entity, x, y, debug_no_limits)
  -- DEBUG: validate data
  --[[for i,it in ipairs(materials_from) do
		for i2,mat in ipairs(it.materials) do
			CellFactory_GetType( mat ) -- will spam errors if not a material name
		end
	end
	for i,it in ipairs(materials_to) do
		CellFactory_GetType( it.material ) -- will spam errors if not a material name
	end]] --

  local parent = EntityGetParent(entity)
  if parent ~= 0 then
    entity = parent
  end

  local frame = GameGetFrameNum()
  -- Start Disable area by: ultimate_mycophile
  -- local last_frame = tonumber(GlobalsGetValue("fungal_shift_last_frame", "-1000000"))
  -- if frame < last_frame + 60 * 60 * 5 and not debug_no_limits then
  -- 	return -- long cooldown
  -- end
  -- End Disable area by: ultimate_mycophile

  local comp_worldstate = EntityGetFirstComponent(GameGetWorldStateEntity(), "WorldStateComponent")
  if (comp_worldstate ~= nil and ComponentGetValue2(comp_worldstate, "EVERYTHING_TO_GOLD")) then
    return -- do nothing in case everything is gold
  end

  local iter = tonumber(GlobalsGetValue("fungal_shift_iteration", "0"))
  if iter >= 20 and not debug_no_limits then
    return
  end


  ---
  local converted_any = false
  local convert_tries = 0
  local from_material_name = ""

  while converted_any == false and convert_tries < 20 do
    local seed2 = 42345 + iter + 1000 * convert_tries
    SetRandomSeed(89346, seed2)
    local rnd = random_create(9123, seed2)
    local from = pick_random_from_table_weighted(rnd, materials_from)
    local to = pick_random_from_table_weighted(rnd, materials_to)
    local held_material = get_held_item_material(entity)

    -- if a potion or pouch is equipped, randomly use main material from it as one of the materials
    if held_material > 0 and random_nexti(rnd, 1, 100) <= 75 then
      if random_nexti(rnd, 1, 100) <= 50 then
        from = {}
        from.materials = { CellFactory_GetName(held_material) }
      else
        to = {}
        to.material = CellFactory_GetName(held_material)
        -- heh he
        if to.material == "gold" and random_nexti(rnd, 1, 1000) ~= 1 then
          to.material = random_from_array(greedy_materials)
        end

        if to.material == "grass_holy" and random_nexti(rnd, 1, 1000) ~= 1 then
          to.material = "grass"
        end
      end
    end

    -- apply effects
    for i, it in ipairs(from.materials) do
      local from_material = CellFactory_GetType(it)
      local to_material = CellFactory_GetType(to.material)
      from_material_name = string.upper(GameTextGetTranslatedOrNot(CellFactory_GetUIName(
        from_material)))
      if from.name_material then
        from_material_name = string.upper(GameTextGetTranslatedOrNot(CellFactory_GetUIName(
          CellFactory_GetType(from
            .name_material))))
      end

      -- convert
      if from_material ~= to_material then
        print(CellFactory_GetUIName(from_material) .. " -> " .. CellFactory_GetUIName(to_material))
        ConvertMaterialEverywhere(from_material, to_material)
        converted_any = true

        -- shoot particles of new material
        GameCreateParticle(CellFactory_GetName(from_material), x - 10, y - 10, 20, rand(-100, 100),
          rand(-100, -30), true,
          true)
        GameCreateParticle(CellFactory_GetName(from_material), x + 10, y - 10, 20, rand(-100, 100),
          rand(-100, -30), true,
          true)

        -- Start Added area by: ultimate_mycophile
        local shift_log = ModSettingGet('ultimate_mycophile.SHOW_SHIFT_LOG') or false
        if shift_log then
          GamePrint('Changed from "' ..
            CellFactory_GetName(from_material) .. '" to "' .. CellFactory_GetName(to_material) .. '"')
        end
        -- End Added area by: ultimate_mycophile
      end
    end

    convert_tries = convert_tries + 1
  end

  -- fx
  if converted_any then
    -- increment only here, in case had very bad luck and didn't get a shift
    GlobalsSetValue("fungal_shift_iteration", tostring(iter + 1))

    -- remove tripping effect
    EntityRemoveIngestionStatusEffect(entity, "TRIP");

    -- audio
    GameTriggerMusicFadeOutAndDequeueAll(5.0)
    GameTriggerMusicEvent("music/oneshot/tripping_balls_01", false, x, y)

    -- particle fx
    local eye = EntityLoad("data/entities/particles/treble_eye.xml", x, y - 10)
    if eye ~= 0 then
      EntityAddChild(entity, eye)
    end

    -- log
    local log_msg = ""
    if from_material_name ~= "" then
      log_msg = GameTextGet("$logdesc_reality_mutation", from_material_name)
      GamePrint(log_msg)
    end
    GamePrintImportant(random_from_array(log_messages), log_msg,
      "data/ui_gfx/decorations/3piece_fungal_shift.png")
    GlobalsSetValue("fungal_shift_last_frame", tostring(frame))

    -- add ui icon
    local add_icon = true
    local children = EntityGetAllChildren(entity)
    if children ~= nil then
      for i, it in ipairs(children) do
        if (EntityGetName(it) == "fungal_shift_ui_icon") then
          add_icon = false
          break
        end
      end
    end

    if add_icon then
      local icon_entity = EntityCreateNew("fungal_shift_ui_icon")
      EntityAddComponent(icon_entity, "UIIconComponent",
        {
          name = "$status_reality_mutation",
          description = "$statusdesc_reality_mutation",
          icon_sprite_file = "data/ui_gfx/status_indicators/fungal_shift.png"
        })
      EntityAddChild(entity, icon_entity)
    end
  end
end

dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

local mod_id = "ultimate_mycophile"
mod_settings_version = 1
mod_settings = {{
  id = "NUMBER_OF_FUNGAL_SHIFTS",
  ui_name = "NumberOfFungalShift",
  ui_description = "",
  value_default = "19",
  text_max_length = 4,
  allowed_characters = "0123456789",
  scope = MOD_SETTING_SCOPE_NEW_GAME,
}, {
  id = "SHIFT_SPAN",
  ui_name = "ShiftSpan",
  ui_description = "This is a shift span frame.",
  value_default = "60",
  text_max_length = 4,
  allowed_characters = "0123456789",
  scope = MOD_SETTING_SCOPE_NEW_GAME,
}, {
  id = "SHOW_SHIFT_LOG",
  ui_name = "Shift Log",
  ui_description = "You can see what has changed into what.",
  value_default = false,
  scope = MOD_SETTING_SCOPE_RUNTIME,
}}

function ModSettingsUpdate(init_scope)
  local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
  mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
  return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
  mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end

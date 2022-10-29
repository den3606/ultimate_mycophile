dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

local mod_id = "twitch-point-integration"
mod_settings_version = 1
mod_settings =
{
  {
		id = "number_of_fungal_shifts",
		ui_name = "NumberOfFungalShift",
		ui_description = "",
    value_default = "19",
    text_max_length = 4,
    allowed_characters = "0123456789",
    scope = MOD_SETTING_SCOPE_NEW_GAME,
  },
  {
		id = "shift_span",
		ui_name = "ShiftSpan",
		ui_description = "This is a shift span frame.",
    value_default = "60",
    text_max_length = 4,
    allowed_characters = "0123456789",
    scope = MOD_SETTING_SCOPE_NEW_GAME,
  }
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end

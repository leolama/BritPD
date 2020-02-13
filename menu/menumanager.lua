_G.BritPD = BritPD or {}
BritPD.modpath = ModPath
BritPD.savepath = SavePath .. "BritPD_settings.txt"
BritPD.settings = {
	option_on = true
}

function BritPD:hasGameLocalization()
    return self.settings.optiongame_on
end

function BritPD:hasMenuLocalization()
    return self.settings.optionmenu_on
end

Hooks:Add("LocalizationManagerPostInit", "BritPDlocalizationmod_loadlocalization", function(localizationmanager)

	BritPD:Load()

	localizationmanager:add_localized_strings(
		{
			BritPD_options_title = "A Brit Plays Payday",
			BritPD_options_desc = "Toggle different changes for A Brit Plays Payday",
			BritPDgame_toggle_title = "In-game Localization",
			BritPDgame_toggle_desc = "Toggle the localization changes for text that appears when in a heist",
			BritPDmenu_toggle_title = "Menu Localization",
			BritPDmenu_toggle_desc = "Toggle the localization changes for text that appears when in the menu's",
			BritPD_optionsmenu_title = "All of these settings require a MAP RESTART or a GAME RELAUNCH"
		}
	)

	if BritPD:hasGameLocalization() then
		localizationmanager:load_localization_file(BritPD.modpath .. "menu/game_localization.json")
	end

	if BritPD:hasMenuLocalization() then
		localizationmanager:load_localization_file(BritPD.modpath .. "menu/menu_localization.json")
	end

end)

function BritPD:Load()
	local file = io.open(self.savepath, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
		self:Save() --create data in case there's no mod save data
	end
	return self.settings
end

function BritPD:Save() --save state of toggle
	local file = io.open(self.savepath,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end


Hooks:Add("MenuManagerInitialize", "BritPDlocalizationmod_createmenu", function(menu_manager)

	MenuCallbackHandler.callback_BritPDgame_toggle_option = function(self,item)
		BritPD.settings.optiongame_on = item:value() == "on"
		BritPD:Save()
	end

	MenuCallbackHandler.callback_BritPDmenu_toggle_option = function(self,item)
		BritPD.settings.optionmenu_on = item:value() == "on"
		BritPD:Save()
	end
	
	MenuCallbackHandler.callback_BritPD_optionstitle = function(self,item)
	end

	MenuHelper:LoadFromJsonFile(BritPD.modpath .. "menu/options.json", BritPD, BritPD.settings)

end)

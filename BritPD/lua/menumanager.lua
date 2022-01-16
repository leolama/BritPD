_G.BritPD = BritPD or {}
BritPD.modpath = ModPath
BritPD.savepath = SavePath .. "BritPD.txt"
BritPD.settings = {
	optiongame_on = true,
	optionmenu_on = true,
	optionheist_on = true,
	optiontype = 1,
	optionskill_on = true
}

function BritPD:hasGameLocalization()
	return self.settings.optiongame_on
end

function BritPD:hasMenuLocalization()
  return self.settings.optionmenu_on
end

function BritPD:hasHeistLocalization()
	return self.settings.optionheist_on
end

function BritPD:hasSkillLocalization()
	return self.settings.optionskill_on
end

Hooks:Add("LocalizationManagerPostInit", "BritPDlocalizationmod_loadlocalization", function(localizationmanager)

	BritPD:Load()

	localizationmanager:add_localized_strings(
		{
			BritPD_options_title = "A Brit Plays Payday",
			BritPD_options_desc = "Toggle different changes for A Brit Plays Payday",
			BritPD_options_menu_title = "These require a MAP RESTART or a GAME RELAUNCH",
			BritPDtype_title = "Type",
			BritPDtype_desc = "Changes the type of Brit you want",
			BritPD_chav = "Chav",
			BritPD_posh = "Posh",
			BritPDmenu_toggle_title = "Menu Changes",
			BritPDmenu_toggle_desc = "Toggle the localization changes for text that appears when in the menu's",
			BritPDgame_toggle_title = "In-game Changes",
			BritPDgame_toggle_desc = "Toggle the localization changes for text that appears when in a heist",
			BritPDheist_toggle_title = "Heist Changes",
			BritPDheist_toggle_desc = "Toggle the localization changes for heist names",
			BritPDskill_toggle_title = "Skill Changes",
			BritPDskill_toggle_desc = "Toggle the localization changes for skill descriptions"
		}
	)

	if BritPD.settings.optiontype == 1 then
		if BritPD:hasGameLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/c_game_localization.json")
		end
		if BritPD:hasMenuLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/c_menu_localization.json")
		end
		if BritPD:hasHeistLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/c_heist_localization.json")
		end
		if BritPD:hasSkillLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/c_skill_localization.json")
		end
	else
		if BritPD:hasGameLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/p_game_localization.json")
		end
		if BritPD:hasMenuLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/p_menu_localization.json")
		end
		if BritPD:hasHeistLocalization() then
			localizationmanager:load_localization_file(BritPD.modpath .. "loc/p_heist_localization.json")
		end
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

	--type
	MenuCallbackHandler.callback_BritPDtype_choice = function(self,item)
		BritPD.settings.optiontype = tonumber(item:value())
		BritPD:Save()
	end

	--game
	MenuCallbackHandler.callback_BritPDgame_toggle_option = function(self,item)
		BritPD.settings.optiongame_on = item:value() == "on"
		BritPD:Save()
	end

	--menu
	MenuCallbackHandler.callback_BritPDmenu_toggle_option = function(self,item)
		BritPD.settings.optionmenu_on = item:value() == "on"
		BritPD:Save()
	end

	--heist
	MenuCallbackHandler.callback_BritPDheist_toggle_option = function(self,item)
		BritPD.settings.optionheist_on = item:value() == "on"
		BritPD:Save()
	end

	--skills
	MenuCallbackHandler.callback_BritPDskill_toggle_option = function(self,item)
		BritPD.settings.optionskill_on = item:value() == "on"
		BritPD:Save()
	end

	MenuCallbackHandler.callback_BritPD_nothing = function(self,item)
		--do nothing
	end

	MenuHelper:LoadFromJsonFile(BritPD.modpath .. "menu/options.json", BritPD, BritPD.settings)

end)

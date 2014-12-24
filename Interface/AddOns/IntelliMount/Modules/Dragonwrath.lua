------------------------------------------------------------
-- Dragonwrath.lua
--
-- Abin
-- 2014/10/22
------------------------------------------------------------

local GetInventoryItemID = GetInventoryItemID

local _, addon = ...

addon:RegisterName("Dragonwrath, Tarecgosa's Rest", 71086, 1)

local function OnEvent()
	addon:SetAttribute("dragonwrath", GetInventoryItemID("player", 16) == 71086)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", OnEvent)

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.dragonwrathFirst = 1
end)

addon:RegisterOptionCallback("dragonwrathFirst", function(value)
	if value then
		frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		OnEvent()
	else
		frame:UnregisterAllEvents()
		addon:SetAttribute("dragonwrath", nil)
	end
end)

addon:AppendVariables([[
	local dragonwrath = self:GetAttribute("dragonwrath")
]])

addon:AppendConditions([[
	elseif dragonwrath then
		macro = "/use 16"
]])
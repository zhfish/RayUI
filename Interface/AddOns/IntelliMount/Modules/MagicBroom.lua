------------------------------------------------------------
-- MagicBroom.lua
--
-- Abin
-- 2014/11/03
------------------------------------------------------------

local GetItemCount = GetItemCount

local _, addon = ...

addon:RegisterName("Magic Broom", 47977)

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.broomFirst = 1
end)

local TODAY = tonumber(date("%m")..date("%d"))

if TODAY < 1018 or TODAY > 1101 then return end -- Only check magic broom during Halloween

local function OnEvent()
	local name
	if GetItemCount(37011) > 0 then
		name = addon:QueryName("Magic Broom")
	end

	addon:SetAttribute("magicBroom", name)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", OnEvent)

addon:RegisterOptionCallback("broomFirst", function(value)
	if value then
		frame:RegisterEvent("BAG_UPDATE")
		OnEvent()
	else
		frame:UnregisterAllEvents()
		addon:SetAttribute("magicBroom", nil)
	end
end)

addon:AppendVariables([[
	local magicBroom = self:GetAttribute("magicBroom")
]])

addon:AppendConditions([[
	elseif magicBroom then
		macro = "/use "..magicBroom
]])
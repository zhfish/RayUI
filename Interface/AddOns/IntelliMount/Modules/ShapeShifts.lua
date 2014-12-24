------------------------------------------------------------
-- ShapeShifts.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local IsSpellKnown = IsSpellKnown

local _, addon = ...

addon:RegisterName("Travel Form", 783)
addon:RegisterName("Cat Form", 768)
addon:RegisterName("Ghost Wolf", 2645)

addon:RegisterEventCallback("OnNewUserData", function(db)
	db.travelFormFirst = 1
end)

if not addon:PlayerClass("DRUID", "SHAMAN") then return end

local IS_DRUID = addon:PlayerClass("DRUID")
local CAT_FORM = addon:QueryName("Cat Form")
local GHOST_WOLF = addon:QueryName("Ghost Wolf")
local TRAVEL_FORM = addon:QueryName("Travel Form")

local hasTravelForm

if IS_DRUID then
	addon:SetAttribute("indoorForm", CAT_FORM)
else
	addon:SetAttribute("indoorForm", GHOST_WOLF)
end

local frame = CreateFrame("Frame")

local function OnEvent()
	if IsSpellKnown(783) then
		hasTravelForm = 1
		addon:SetAttribute("travelForm", TRAVEL_FORM)
		addon:SetAttribute("combatForm", TRAVEL_FORM)
		frame:UnregisterAllEvents()
	elseif IS_DRUID then
		addon:SetAttribute("combatForm", CAT_FORM)
	else
		addon:SetAttribute("combatForm", GHOST_WOLF)
	end

end

frame:SetScript("OnEvent", function(self, event, arg1)
	if not arg1 then
		OnEvent()
	end
end)

addon:RegisterEventCallback("OnInitialize", function()
	frame:RegisterEvent("SPELLS_CHANGED")
	OnEvent()
end)

addon:RegisterOptionCallback("travelFormFirst", function(value)
	if value and hasTravelForm then
		addon:SetAttribute("travelForm", TRAVEL_FORM)
	else
		addon:SetAttribute("travelForm", nil)
	end
end)

addon:AppendVariables([[
	local indoorForm = self:GetAttribute("indoorForm")
	local combatForm = self:GetAttribute("combatForm")
	local travelForm = self:GetAttribute("travelForm")
]])

addon:AppendConditions([[
	elseif indoorForm and isIndoor then
		macro = "/cast "..indoorForm
	elseif combatForm and isInCombat then
		macro = "/cast "..combatForm
	elseif travelForm and (isFlyable or isSwimming) then
		macro = "/cast "..travelForm
]])


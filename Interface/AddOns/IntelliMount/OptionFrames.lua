------------------------------------------------------------
-- OptionFrames.lua
--
-- Abin
-- 2014/10/21
------------------------------------------------------------

local format = format
local type = type
local GetBindingKey = GetBindingKey
local GetItemInfo = GetItemInfo
local NOT_BOUND = NOT_BOUND

local _, addon = ...

local L = addon.L

BINDING_HEADER_INTELLIMOUNT_TITLE = "IntelliMount"
BINDING_NAME_INTELLIMOUNT_HOTKEY1 = L["summon regular mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY2 = L["summon passenger mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY3 = L["summon vendors mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY4 = L["summon water surface mount"]
BINDING_NAME_INTELLIMOUNT_HOTKEY5 = L["summon underwater mount"]

addon.db = {}

local frame = UICreateInterfaceOptionPage("IntelliMountOptionFrame", "IntelliMount", L["desc"])
addon.optionFrame = frame

local group = frame:CreateMultiSelectionGroup(L["summon regular mount"])
frame:AnchorToTopLeft(group, 0, -10)

local function CreateDummyCheck(text)
	local button = group:AddButton(text)
	button:Disable()
	button.text:SetTextColor(1, 1, 1)
	return button
end

CreateDummyCheck(format(L["auto specia forms"], addon:QueryName("Travel Form"), addon:QueryName("Cat Form"), addon:QueryName("Ghost Wolf")))
group:AddButton(format(L["prefer travel form"], addon:QueryName("Travel Form")), "travelFormFirst", 1)
group:AddButton(format(L["prefer seahorse"], addon:QueryName("Abyssal Seahorse")), "seahorseFirst", 1)
local dragonwrathButton = group:AddButton(format(L["prefer dragonwrath"], addon:QueryName("Dragonwrath, Tarecgosa's Rest")), "dragonwrathFirst", 1)
group:AddButton(format(L["prefer magic broom"], addon:QueryName("Magic Broom")), "broomFirst", 1)
CreateDummyCheck(L["summon system random mounts otherwise"])
group:AddButton(L["enable debug mode"], "debugMode")

group.buttonId = 1
group.hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontGreen")
group.hotkeyText:SetPoint("LEFT", group, "RIGHT", 4, 0)

function group:OnCheckInit(value)
	if value then
		return addon.db[value]
	end

	return 1
end

function group:OnCheckChanged(value, checked)
	addon.db[value] = checked
	addon:BroadcastOptionEvent(value, checked)
end

local comboBoxes = {}

local function Combo_OnComboInit(self)
	return addon.db[self.dbKey]
end

local function Combo_OnComboChanged(self, value)
	if value then
		addon.db[self.dbKey] = value
		addon:BroadcastOptionEvent("utilityMount", self.key, value)
	end
end

local function Combo_UpdateStats(self)
	local i
	for i = 1, self:NumLines() do
		local data = self:GetLineData(i)
		data.disabled = not addon:IsMountLearned(data.value)
	end
end

local function Combo_UpdateHotkeyText(self)
	local key = GetBindingKey("INTELLIMOUNT_HOTKEY"..self.buttonId)
	self.hotkeyText:SetText("<"..(key or NOT_BOUND)..">")
	if key then
		self.hotkeyText:SetTextColor(0, 1, 0)
	else
		self.hotkeyText:SetTextColor(0.5, 0.5, 0.5)
	end
end

local function CreateMountCombo(text, key)
	local button = addon:GetActionButton(key)
	if not button then
		return -- Should never happen
	end

	local combo = frame:CreateComboBox(text, nil, 1)
	tinsert(comboBoxes, combo)
	combo:SetWidth(240)
	combo.buttonId = button:GetID()
	combo.key = key
	combo.dbKey = button.dbKey

	if combo.buttonId == 2 then
		combo:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 4, -36)
	else
		local prev = comboBoxes[combo.buttonId - 2]
		combo:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -30)
	end

	local hotkeyText = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	combo.hotkeyText = hotkeyText
	hotkeyText:SetPoint("LEFT", combo.text, "RIGHT", 4, 0)

	local i
	for i = 1, addon:GetNumUtilityMounts() do
		local data = addon:GetUtilityMountData(i)
		if data[key] then
			combo:AddLine(data.name, data.name, data.icon)
		end
	end

	combo.OnComboInit = Combo_OnComboInit
	combo.OnComboChanged = Combo_OnComboChanged

	return combo
end

CreateMountCombo(L["summon passenger mount"], "passenger")
CreateMountCombo(L["summon vendors mount"], "vendor")
CreateMountCombo(L["summon water surface mount"], "surface")
CreateMountCombo(L["summon underwater mount"], "underwater")

frame:SetScript("OnShow", function(self)
	Combo_UpdateHotkeyText(group)
	dragonwrathButton.text:SetText(format(L["prefer dragonwrath"], addon:QueryName("Dragonwrath, Tarecgosa's Rest")))
	addon:UpdateUtilityMounts()

	local _, combo
	for _, combo in ipairs(comboBoxes) do
		Combo_UpdateStats(combo)
		Combo_UpdateHotkeyText(combo)
	end

	-- For taking an enUS screenshot...
	if addon.FORCE_ENUS then
		comboBoxes[1]:SetText("X-53 Touring Rocket")
		comboBoxes[2]:SetText("Traveler's Tundra Mammoth")
		comboBoxes[3]:SetText("Azure Water Strider")
		comboBoxes[4]:SetText("Riding Turtle")
	end
end)

local function InitOption(key)
	addon:BroadcastOptionEvent(key, addon.db[key])
end

addon:RegisterEventCallback("OnInitialize", function(db)
	InitOption("travelFormFirst")
	InitOption("seahorseFirst")
	InitOption("dragonwrathFirst")
	InitOption("broomFirst")
	InitOption("debugMode")

	local _, combo
	for _, combo in ipairs(comboBoxes) do
		addon:BroadcastOptionEvent("utilityMount", combo.key, db[combo.dbKey])
	end
end)
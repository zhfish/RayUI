------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2014/11/03
------------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local pairs = pairs
local type = type
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo

local addon = LibAddonManager:CreateAddon(...)

addon:RegisterDB("IntelliMountDB")
addon:RegisterSlashCmd("intellimount", "inm")

addon.FORCE_ENUS = nil -- Set to true if taking an enUS screenshot...

local registeredNames = {}
local actionButtons = {}

function addon:RegisterName(key, id, item)
	if type(key) ~= "string" or type(id) ~= "number" or id < 1 then
		return
	end

	local name
	if item then
		name = GetItemInfo(id)
	else
		name = GetSpellInfo(id)
		if not name then
			return
		end
	end

	local data = { id = id, name = name }
	registeredNames[key] = data
	return name
end

function addon:QueryName(key)
	-- For taking an enUS screenshot...
	if self.FORCE_ENUS then
		return key
	end

	local data = registeredNames[key]
	if not data then
		return
	end

	if not data.name then
		data.name = GetItemInfo(data.id)
	end

	return data.name or "Hitem:"..data.id
end

function addon:GetActionButton(key)
	return actionButtons[key]
end

local function CreateActionButton(name, id, key, dbKey, bindingName, templates)
	local button = CreateFrame("Button", name, UIParent, templates or "SecureActionButtonTemplate")
	actionButtons[key] = button
	button:SetID(id)
	addon:RegisterBindingClick(bindingName, button)

	if dbKey then
		button:SetAttribute("type", "spell")
		button.dbKey = dbKey
		addon:RegisterOptionCallback(dbKey, function(value)
			button:SetAttribute("spell", value)
		end)
	end

	return button
end

------------------------------------------------------------
-- Snippets definitions
------------------------------------------------------------

local SNIPPET_VAR_DEF = [[
	local isOnVehicle = UnitHasVehicleUI("player")
	local isMounted = IsMounted()
	local isInCombat = PlayerInCombat()
	local isIndoor = IsIndoors()
	local isFlyable = IsFlyableArea()
	local isSwimming = IsSwimming()
]] -- Module variables appeneded here

local SNIPPET_CON_STA = [[

	local macro
	if isOnVehicle then
		macro = "/leavevehicle"
	elseif isMounted then
		macro = "/dismount"
]] -- Module condition statements appeneded here

local SNIPPET_CON_END = [[

	else
		macro = "/script C_MountJournal.Summon(0)"
	end

	self:SetAttribute("macrotext", macro)
]]

------------------------------------------------------------

function addon:AppendVariables(snippet)
	if type(snippet) == "string" then
		SNIPPET_VAR_DEF = SNIPPET_VAR_DEF.."\n"..snippet
	end
end

function addon:AppendConditions(snippet)
	if type(snippet) == "string" then
		SNIPPET_CON_STA = SNIPPET_CON_STA.."\n"..snippet
	end
end

local button = CreateActionButton("IntelliMountNormalButton", 1, "normal", "dummy", "INTELLIMOUNT_HOTKEY1", "SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")

button:SetAttribute("type", "macro")

button:SetScript("OnMouseDown", function(self)
	addon:BroadcastEvent("PreClick", self)
end)

button:SetScript("PostClick", function(self)
	if addon.db.debugMode then
		addon:Print(self:GetAttribute("macrotext"))
	end

	addon:BroadcastEvent("PostClick", self)
end)

CreateActionButton("IntelliMountPassengerButton", 2, "passenger", "passengerMount", "INTELLIMOUNT_HOTKEY2")
CreateActionButton("IntelliMountVendorsButton", 3, "vendor", "vendorMount", "INTELLIMOUNT_HOTKEY3")
CreateActionButton("IntelliMountWaterSurfaceButton", 4, "surface", addon:PlayerClass("WARLOCK") and "warlockSurfaceMount" or "surfaceMount", "INTELLIMOUNT_HOTKEY4")
CreateActionButton("IntelliMountUnderwaterButton", 5, "underwater", "underwaterMount", "INTELLIMOUNT_HOTKEY5")

addon:RegisterOptionCallback("utilityMount", function(key, value)
	local button = addon:GetActionButton(key)
	if button then
		button:SetAttribute("spell", value)
	end
end)

local pendingAttributes = {}

function addon:SetAttribute(attribute, value)
	if button:GetAttribute(attribute) ~= value then
		if InCombatLockdown() then
			pendingAttributes[attribute] = value
		else
			button:SetAttribute(attribute, value)
		end
	end
end

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")

function addon:OnInitialize(db, dbIsNew)
	if dbIsNew then
		addon:BroadcastEvent("OnNewUserData", db)
	end

	addon:BroadcastEvent("OnInitialize", db)
	button:SetAttribute("_onmouseup", SNIPPET_VAR_DEF..SNIPPET_CON_STA..SNIPPET_CON_END)
end

function addon:PLAYER_LOGIN()
	if IsAddOnLoaded("EasyMount") then
		DisableAddOn("EasyMount") -- Disable the old addon
	end
end

function addon:PLAYER_REGEN_ENABLED()
	local attr, value
	for attr, value in pairs(pendingAttributes) do
		button:SetAttribute(attr, value)
	end

	wipe(pendingAttributes)
end
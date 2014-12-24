
-----------------------------------------------------------
-- LibAddonManager.lua
-----------------------------------------------------------
-- Take the global "..." (addonName, addon) as parameter to
-- initialize an addon addon.
--
-- Abin (2014-11-04)

-----------------------------------------------------------
-- API Documentation:
-----------------------------------------------------------

-- addon = LibAddonManager:CreateAddon(addonName, addon) -- Take over the addon object

-- addon:RegisterDB("dbName" [, "chardbName"])
-- addon:RegisterSlashCmd("command1" [, "command2"])
-- addon:RegisterBindingClick("name", button)

-- addon:RegisterEvent("event" [, func])
-- addon:RegisterEvent("event" [, "method"])
-- addon:UnregisterEvent("event")
-- addon:RegisterAllEvents()
-- addon:UnregisterAllEvents()

-- addon:RegisterTick(interval)
-- addon:UnregisterTick()
-- addon:SetInterval(interval)
-- addon:IsTicking()

-- addon:BroadcastEvent("event" [, ...])
-- addon:RegisterEventCallback("event", func [, arg1])
-- addon:BroadcastOptionEvent(option [, ...])
-- addon:RegisterOptionCallback("option", func [, arg1])

-- addon:PlayerClass(["class1", ...]) -- Returns player class if the list is empty, or the player class is in the list
-- addon:PlayerRace(["race1", ...]) -- Returns player race if the list is empty, or the player race is in the list

-----------------------------------------------------------
-- Callback functions:
-----------------------------------------------------------

-- addon:OnInitialize(db, dbIsNew, chardb, chardbIsNew) -- Called when ADDON_LOADED event fires and addon name matches
-- addon:OnTick(elapsed) -- Fires when ticking
-- addon:OnClashCmd(text) -- Fires when the user types a slash command registered by this addon
-- addon:OnEvent(event, ...) -- Fires when an event fires and this callback is defined

-----------------------------------------------------------

local type = type
local CreateFrame = CreateFrame
local tinsert = tinsert
local GetAddOnMetadata = GetAddOnMetadata
local tonumber = tonumber
local tostring = tostring
local select = select
local strupper = strupper
local strfind = strfind
local strtrim = strtrim
local wipe = wipe
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local _G = _G

local VERSION = 1.02
local PRIVATE = "{FDC6BF81-209A-4E0D-86EC-CA51B171CC55}"

local lib = _G.LibAddonManager
if type(lib) == "table" then
	local version = lib.version
	if type(version) == "number" and version >= VERSION then
		return
	end
else
	lib = { name = "LibAddonManager", version = VERSION }
	_G.LibAddonManager = lib
end

local function Addon_RegisterEvent(self, event, method)
	if type(method) ~= "function" and type(method) ~= "string" then
		method = nil
	end

	local frame = self[PRIVATE].frame
	if not frame:IsEventRegistered(event) then
		frame:RegisterEvent(event)
	end
	frame.events[event] = method
end

local function Addon_UnregisterEvent(self, event)
	local frame = self[PRIVATE].frame
	frame.events[event] = nil
	if frame:IsEventRegistered(event) then
		frame:UnregisterEvent(event)
	end
end

local function Addon_IsEventRegistered(self, event)
	return self[PRIVATE].frame:IsEventRegistered(event)
end

local function Addon_RegisterAllEvents(self)
	return self[PRIVATE].frame:RegisterAllEvents()
end

local function Addon_UnregisterAllEvents(self)
	return self[PRIVATE].frame:UnregisterAllEvents()
end

local function Addon_SetInterval(self, interval)
	if type(interval) ~= "number" or interval < 0.2 then
		interval = 0.2
	end

	local frame = self[PRIVATE].frame
	frame.elapsed = 0
	frame.tickSeconds = interval
end

local function Addon_RegisterTick(self, interval)
	Addon_SetInterval(self, interval)
	local frame = self[PRIVATE].frame
	frame:Show()
end

local function Addon_UnregisterTick(self)
	local frame = self[PRIVATE].frame
	frame:Hide()
	frame.tickSeconds = nil
end

local function Addon_IsTicking(self)
	local frame = self[PRIVATE].frame
	return frame:IsShown()
end

local function Frame_OnEvent(self, event, ...)
	local addon = self.parentAddon
	if event == "ADDON_LOADED" and addon.name == ... then
		local dbName = addon[PRIVATE].dbName
		local chardbName = addon[PRIVATE].chardbName
		local db, dbIsNew, chardb, chardbIsNew
		if dbName then
			db = _G[dbName]
			if type(db) ~= "table" then
				dbIsNew = 1
				db = {}
				_G[dbName] = db
			end

			addon.db = db
		end

		if chardbName then
			chardb = _G[chardbName]
			if type(chardb) ~= "table" then
				chardbIsNew = 1
				chardb = {}
				_G[chardbName] = chardb
			end

			addon.chardb = chardb
		end

		if type(addon.OnInitialize) == "function" then
			addon:OnInitialize(db, dbIsNew, chardb, chardbIsNew)
		end
	end

	if type(addon.OnEvent) == "function" then
		addon:OnEvent(event, ...)
	else
		local func = self.events[event]
		if not func then
			func = addon[event]
		elseif type(func) ~= "function" then -- string, number, etc
			func = addon[func]
		end

		if type(func) == "function" then
			func(addon, ...)
		end
	end
end

local function Frame_OnUpdate(self, elapsed)
	local tickSeconds = self.tickSeconds
	if not tickSeconds then
		self:Hide()
		return
	end

	local updateElapsed = (self.elapsed or 0) + elapsed
	if updateElapsed >= tickSeconds then
		local addon = self.parentAddon
		if addon.OnTick then
			addon:OnTick(updateElapsed)
		end
		updateElapsed = 0
	end
	self.elapsed = updateElapsed
end

local function Addon_BroadcastEvent(self, event, ...)
	local callbacks = self[PRIVATE].eventCallbacks[event]
	if not callbacks then
		return
	end

	local i
	for i = 1, #callbacks do
		local arg1 = callbacks[i].arg1
		if arg1 then
			callbacks[i].func(arg1, ...)
		else
			callbacks[i].func(...)
		end
	end
end

local function Addon_RegisterEventCallback(self, event, func, arg1)
	if type(event) ~= "string" or type(func) ~= "function" then
		return
	end

	local callbacks = self[PRIVATE].eventCallbacks[event]
	if not callbacks then
		callbacks = {}
		self[PRIVATE].eventCallbacks[event] = callbacks
	end

	tinsert(callbacks, { func = func, arg1 = arg1 })
end

local OPTION_EVENT_PREFX = "OnOptionChanged_" -- Option event name prefix

local function Addon_BroadcastOptionEvent(self, option, ...)
	if type(option) == "string" then
		Addon_BroadcastEvent(self, OPTION_EVENT_PREFX..option, ...)
	end
end

local function Addon_RegisterOptionCallback(self, option, func, arg1)
	if type(option) == "string" then
		Addon_RegisterEventCallback(self, OPTION_EVENT_PREFX..option, func, arg1)
	end
end

local function Addon_RegisterDB(self, dbName, chardbName)
	if type(dbName) == "string" then
		self[PRIVATE].dbName = dbName
	end

	if type(chardbName) == "string" then
		self[PRIVATE].chardbName = chardbName
	end
end

local function Addon_RegisterSlashCmd(self, cmd1, cmd2)
	local UPPER_NAME = strupper(self.name)
	if type(cmd1) == "string" and strfind(cmd1, "/") ~= 1 then
		cmd1 = "/"..cmd1
	end

	if type(cmd2) == "string" and strfind(cmd2, "/") ~= 1 then
		cmd2 = "/"..cmd2
	end

	_G["SLASH_"..UPPER_NAME..1] = cmd1
	_G["SLASH_"..UPPER_NAME..2] = cmd2

	SlashCmdList[UPPER_NAME] = function(text)
		if type(self.OnClashCmd) == "function" then
			self:OnClashCmd(strtrim(text))
			return
		end

		local frame = self.optionFrame or self.optionPage or self.frame
		if not frame then
			return
		end

		if type(frame.Toggle) == "function" then
			frame:Toggle()
		elseif type(frame.Open) == "function" then
			frame:Open()
		elseif frame:IsShown() then
			frame:Hide()
		else
			frame:Show()
		end
	end
end

function lib:CreateAddon(name, addon)
	if type(name) ~= "string" or type(addon) ~= "table" then
		return
	end

	_G[name] = addon
	addon.version = GetAddOnMetadata(name, "Version") or "1.0"
	addon.numericVersion = tonumber(addon.version) or 1.0
	addon.name = name

	local frame = CreateFrame("Frame")
	addon[PRIVATE] = { frame = frame, eventCallbacks = {} }
	frame.parentAddon = addon
	frame.events = {}
	frame:Hide()

	frame:SetScript("OnEvent", Frame_OnEvent)
	frame:SetScript("OnUpdate", Frame_OnUpdate)
	frame:RegisterEvent("ADDON_LOADED")

	addon.Print = lib.Print
	addon.PlayerClass = lib.PlayerClass
	addon.PlayerRace = lib.PlayerRace
	addon.RegisterBindingClick = lib.RegisterBindingClick

	addon.RegisterDB = Addon_RegisterDB
	addon.RegisterSlashCmd = Addon_RegisterSlashCmd

	addon.RegisterEvent = Addon_RegisterEvent
	addon.UnregisterEvent = Addon_UnregisterEvent
	addon.IsEventRegistered = Addon_IsEventRegistered
	addon.RegisterAllEvents = Addon_RegisterAllEvents
	addon.UnregisterAllEvents = Addon_UnregisterAllEvents

	addon.RegisterTick = Addon_RegisterTick
	addon.UnregisterTick = Addon_UnregisterTick
	addon.SetInterval = Addon_SetInterval
	addon.IsTicking = Addon_IsTicking

	addon.BroadcastEvent = Addon_BroadcastEvent
	addon.RegisterEventCallback = Addon_RegisterEventCallback
	addon.BroadcastOptionEvent = Addon_BroadcastOptionEvent
	addon.RegisterOptionCallback = Addon_RegisterOptionCallback

	return addon
end

--------------------------------------------------------
-- General infomation
--------------------------------------------------------

function lib:Print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..self.name..":|r "..tostring(msg), r or 0.5, g or 0.75, b or 1)
end

local PLAYER_CLASS = select(2, UnitClass("player"))
local PLAYER_RACE = select(2, UnitRace("player"))

function lib:PlayerClass(...)
	local COUNT = select("#", ...)
	if COUNT == 0 then
		return PLAYER_CLASS
	end

	local i
	for i = 1, COUNT do
		if select(i, ...) == PLAYER_CLASS then
			return PLAYER_CLASS
		end
	end
end

function lib:PlayerRace(...)
	local COUNT = select("#", ...)
	if COUNT == 0 then
		return PLAYER_RACE
	end

	local i
	for i = 1, COUNT do
		if select(i, ...) == PLAYER_RACE then
			return PLAYER_RACE
		end
	end
end

--------------------------------------------------------
-- Stuff for binding clicks
-- The code automatically update key bindings for defined
-- action buttons.
--------------------------------------------------------

local bindingFrame = lib.bindingFrame
if not bindingFrame then
	bindingFrame = CreateFrame("Frame")
	lib.bindingFrame = bindingFrame
end

local bindingList = bindingFrame.bindingList
if not bindingList then
	bindingList = {}
	bindingFrame.bindingList = bindingList
end

function lib:RegisterBindingClick(name, button)
	if type(name) == "string" and type(button) == "table" then
		bindingList[name] = button
	end
end

local function ApplyAllBindings()
	local name, button
	for name, button in pairs(bindingList) do
		ClearOverrideBindings(button)
		local key1, key2 = GetBindingKey(name)
		if key2 then
			SetOverrideBindingClick(button, false, key2, button:GetName())
		end

		if key1 then
			SetOverrideBindingClick(button, false, key1, button:GetName())
		end
	end
end

bindingFrame:RegisterEvent("PLAYER_LOGIN")
bindingFrame:RegisterEvent("UPDATE_BINDINGS")
bindingFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

bindingFrame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" or event == "UPDATE_BINDINGS" then
		if InCombatLockdown() then
			self.hasPending = 1 -- Delay call
		else
			ApplyAllBindings()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if self.hasPending then
			self.hasPending = nil
			ApplyAllBindings()
		end
	end
end)
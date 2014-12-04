
local _, ns = ...;

ns.language=GetLocale();
ns.ability_locales = {};
ns.counter_locales = {};
ns.classspec_locales = {};
ns.faction_locales = {};
ns.follower_locales = {};
ns.npc_locales = {};
ns.zone_locales = {};
ns.languages = {
	["deDE"] = "Deutsch",
	["enUS"] = "English",
	["esES"] = "Español",
	["frFR"] = "Français",
	["itIT"] = "Italiano",
	["ptBR"] = "Português",
	--["ruRU"] = "Русский",
	--["jpJP"] = "日本人",
	--["koKR"] = "한국의",
	--["zhCN"] = "中国",
	--["zhTW"] = "中國",
}

if(ns.language:sub(1,2)=="pt") and (ns.language~="ptBR") then
	ns.language="ptBR";
elseif(ns.language:sub(1,2)=="es") and (ns.language~="esES") then
	ns.language="esES";
elseif(ns.language:sub(1,2)=="en") and (ns.language~="enUS") then
	ns.language="esES";
elseif(ns.language:sub(1,2)=="zh") and (ns.language~="zhTW") then
	ns.language="zhTW";
end


ns.locale = setmetatable({},{__index=function(t,k)
	local v = tostring(k);
	rawset(t,k,v);
	return v;
end})

--[[
local bigData = {strings={},ability={},counter={},classspec={},faction={},follower={},npc={},zone={}};

ns.addLocale = function(t,d)
	
end

ns.locale2 = setmetatable(bigData,{
	__index=function(t,k)
		local v = tostring(k);
		if (t.strings[v]) then
			return t.strings[v]
		end
		rawset(t.strings,k,v);
		return v;
	end,
	__call=function(t,a,b)
		
	end
});

]]

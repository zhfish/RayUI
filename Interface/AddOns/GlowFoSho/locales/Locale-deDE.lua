local L = LibStub("AceLocale-3.0"):NewLocale("GlowFoSho", "deDE") 
if not L then return end

--commands
L["/gfs"] = "/gfs"
L["standby"] = "standby"
L["Enable/disable the addon"] = "Addon aktivieren/deaktivieren"
L["Active"] = "aktiv"
L["Suspended"] = "inaktiv"

--dewdrop menu
L["Show Weapon Link"] = "Waffenlink"
L["Displays the link of the enchanted weapon in the chat frame."] = "Zeige die verzauberte Waffe als Itemlink im Chat"
L["Show Enchant Link"] = "Verzauberungslink"
L["Displays the link of the enchant currently on the weapon in the chat frame."] = "Zeige die momentane Verzauberung als Link im Chat"		-- changed to not warn about disconnects
L["Show Glowless Enchants"] = "nicht-leuchtende"
L["Allows you to preview enchants which do not add glow to a weapon."] = "Zeigt auch Vezauberungen die der Waffe keinen Leuchteffekt verleihen"
L["Show Classic Enchants"] = "Classic Verzauberungen"
L["Allows you to preview Classic enchants."] = "Zeigt auch Verzauberungen aus Classic WoW."
L["Show BC Enchants"] = "BC Verzauberungen"
L["Allows you to preview BC enchants."] = "Zeigt auch Verzauberungen aus Burning Crusade."
L["Show WotLK Enchants"] = "WotLK Verzauberungen"
L["Allows you to preview WotLK enchants."] = "Zeigt auch Verzauberungen aus WotLK."
L["Show Cata Enchants"] = "Cata Verzauberungen"
L["Allows you to preview Cata enchants."] = "Zeigt auch Verzauberungen aus Cata."
L["Show Mop Enchants"] = "MoP Verzauberungen"
L["Allows you to preview Mop enchants."] = "Zeigt auch Verzauberungen aus MoP."
L["Show DK Runes"] = "DK Runen"
L["Allows you to preview Runes which are created by DKs."] = "Zeigt auch Runen der Todesritter."
L["Show Only Compatible Enchants"] = "nur kompatible"
L["Filters out enchants that cannot be applied to the currently previewed weapon."] = "Zeigt nur Verzauberungen die auf die momentane Waffe angewendet werden k\195\182nnen"
L["Enchants"] = "Verzauberungen"
L["List of weapon enchants you can preview."] = "Verzauberungen ausw\195\164hlen"
L["Clear"] = "Entfernen"
L["Removes enchant from the weapon in the dressing room."] = "Entfernt die momentane Verzauberung der Waffe"

--messages
L["There is no enchant on the weapon or enchant unknown."] = "Keine oder unbekannte Verzauberung auf der Waffe"

--whisper enchant
L["!glow"] = "!glow"		-- string to request enchant
L["glow>"] = "glow>"		-- reply string
L["Unknown enchant."] = "unbekannte Verzauberung"		-- enchant name was not found in the database
L["No weapon enchant link specified."] = "kein Verzauberungslink gefunden"		-- enchant link was not found in the query
L["No weapon link specified."] = "kein Waffenlink gefunden"			-- weapon link was not found in the query
L["Syntax: !glow <weapon link> <enchant link>"] = "Syntax: !glow <weapon link> <enchant link>"	-- syntax message displayed when querried with !glow only

--enchants as they appear in the list
L["Agility (2H)"] = "Beweglichkeit (2H)"
L["Agility"] = "Beweglichkeit"
L["Battlemaster"] = "Meister des Kampfes"
L["Crusader"] = "Kreuzfahrer"
L["Deathfrost"] = "Todesk\195\164lte"
L["Demonslaying"] = "D\195\164monent\195\182ten"
L["Executioner"] = "Scharfrichter"
L["Fiery Weapon"] = "Feurige Waffe"
L["Greater Agility"] = "Gro\195\159e Beweglichkeit"
L["Greater Impact (2H)"] = "Gro\195\159er Einschlag (2H)"
L["Greater Striking"] = "Gro\195\159es Schlagen"
L["Healing Power"] = "Heilkraft"
L["Icy Chill"] = "Eisiger Hauch"
L["Impact (2H)"] = "Einschlag (2H)"
L["Lesser Beastslayer"] = "Geringer Wildtiert\195\182ter"
L["Lesser Elemental Slayer"] = "Geringer Elementart\195\182ter"
L["Lesser Impact (2H)"] = "Geringer Einschlag (2H)"
L["Lesser Intellect (2H)"] = "Geringe Intelligenz (2H)"
L["Lesser Spirit (2H)"] = "Geringe Willenskraft (2H)"
L["Lesser Striking"] = "Geringes Schlagen"
L["Lifestealing"] = "Lebensdiebstahl"
L["Major Agility (2H)"] = "Erhebliche Beweglichkeit (2H)"
L["Major Healing"] = "Erhebliche Heilung"
L["Major Intellect (2H)"] = "Erhebliche Intelligenz (2H)"
L["Major Intellect"] = "Erhebliche Intelligenz"
L["Major Spellpower"] = "Erhebliche Zaubermacht"
L["Major Spirit (2H)"] = "Erhebliche Willenskraft (2H)"
L["Major Striking"] = "Erhebliches Schlagen"
L["Mighty Intellect"] = "M\195\164chtige Intelligenz"
L["Mighty Spirit"] = "M\195\164chtige Willenskraft"
L["Minor Beastslayer"] = "Schwacher Wildtiert\195\182ter"
L["Minor Impact (2H)"] = "Schwacher Einschlag (2H)"
L["Minor Striking"] = "Schwaches Schlagen"
L["Mongoose"] = "Mungo"
L["Potency"] = "Potenz"
L["Savagery (2H)"] = "Unb\195\164ndigkeit (2H)"
L["Soulfrost"] = "Seelenfrost"
L["Spell Power"] = "Zauberkraft"
L["Spellsurge"] = "Zauberflut"
L["Strength"] = "St\195\164rke"
L["Striking"] = "Schlagen"
L["Sunfire"] = "Sonnenfeuer"
L["Superior Impact (2H)"] = "\195\156berragender Einschlag (2H)"
L["Superior Striking"] = "\195\156berragendes Schlagen"
L["Unholy Weapon"] = "Unheilige Waffe"
L["Winter's Might"] = "Wintermacht"
L["Greater Potency"] = "Gro\195\159e Potenz"
L["Greater Savagery (2H)"] = "Gro\195\159e Unb\195\164ndigkeit (2H)"
L["Exceptional Spellpower"] = "Au\195\159ergew\195\182hnliche Zaubermacht"
L["Exceptional Agility"] = "Au\195\159ergew\195\182hnliche Beweglichkeit"
L["Exceptional Spirit"] = "Au\195\159ergew\195\182hnliche Willenskraft"
L["Icebreaker"] = "Eisbrecher"
L["Massacre (2H)"] = "Massaker (2H)"
L["Scourgebane (2H)"] = "Gei\195\159elbann (2H)"
L["Giant Slayer"] = "Riesent\195\182ter"
L["Mighty Spellpower"] = "M\195\164chtige Zaubermacht"
L["Superior Potency"] = "\195\156berragende Potenz"
L["Accuracy"] = "Pr\195\164zision"
L["Berserking"] = "Berserker"
L["Black Magic"] = "Schwarzmagie"
L["Lifeward"] = "Lebensw\195\164chter"
L["Titanium Weapon Chain"] = "Titanwaffenkette"
L["Blood Draining"] = "Blutsauger"
L["Blade Ward"] = "Klingenbarrikade"
L["Spellpower (2H)"] = "Zaubermacht (Stab)"
L["Greater Spellpower (2H)"] = "Gro\195\159e Zaubermacht (Stab)"
L["Mighty Agility (2H)"] = "M\195\164chtige Beweglichkeit (2H)"
L["Avalanche"] = "Lawine"
L["Elemental Slayer"] = "Elementart\195\182ter"
L["Heartsong"] = "Gesang des Herzens"
L["Hurricane"] = "Hurrikan"
L["Landslide"] = "Erdrutsch"
L["Mending"] = "Heilung"
L["Power Torrent"] = "Machtstrom"
L["Windwalk"] = "Windwandler"
L["Rune of Cinderglacier"] = "Rune des schwarzen Gletschers"
L["Rune of Razorice"] = "Rune des schneidenden Eises"
L["Rune of Spellbreaking"] = "Rune des Zauberbrechens"
L["Rune of Spellshattering (2H)"] = "Rune des Zauberberstens (2H)"
L["Rune of Lichbane"] = "Rune des Lichbanns"
L["Rune of Swordbreaking"] = "Rune des Schwertbrechens"
L["Rune of Swordshattering (2H)"] = "Rune des Schwertberstens (2H)"
L["Rune of the Fallen Crusader"] = "Rune des gefallenen Kreuzfahrers"
L["Rune of the Nerubian Carapace"] = "Rune der nerubischen Panzerung"
L["Rune of the Stoneskin Gargoyle (2H)"] = "Rune des Steinhautgargoyles (2H)"
L["Pyrium Weapon Chain"] = "Pyriumwaffenkette"
L["Elemental Force"] = "Elementarkraft"
L["Windsong"] = "Windweise"
L["Colossus"] = "Koloss"
L["Dancing Steel"] = "Tanzender Stahl"
L["Jade Spirit"] = "Jadegeist"
L["River's Song"] = "Flussgesang"
L["Living Steel Weapon Chain"] = "Waffenkette aus lebendigem Stahl"

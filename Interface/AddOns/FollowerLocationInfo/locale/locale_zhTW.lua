
if not LOCALE_zhTW then return end

local addon, ns = ...;
local L=ns.locale;


L["Location"] = "位置";
L["Description"] = "說明";
L["Image"] = "圖片";
L["Currency"] = "貨幣";
L["Event"] = "事件";
L["Coordinations"] = "座標";
L["Requirements"] = "需要條件";
L["Quests"] = "任務";
L["Quest row"] = "任務串";
L["(In questlog)"] = "(在任務日誌內)";
L["(Completed)"] = "(已完成)";
L["On WoWHead"] = "在WoWHead上查看";
L["Show minimap button"] = "顯示小地圖按鈕";
L["Minimap"] = "小地圖";
L["Show collected followers"] = "顯示已收集的追隨者";
L["Show hidden followers"] = "顯示隱藏追隨者";
L["Misc."] = "其他";
L["Show/Hide %s's minimap button"] = "顯示/隱藏 %s的小地圖按鈕";
L["Show FollowerID in follower list"] = "在追隨者列表顯示追隨者ID";
L["Show coordination frame"] = "顯示座標框架";
L["Show coordinations on broker"] = "在broker顯示座標";
L["Show follower count on broker"] = "在broker顯示追隨者統計";
L["Follower list"] = "追隨者列表";
L["Missing quest..."] = "缺少任務...";
L["Error: quest name not found..."] = "錯誤：沒找到任務名稱...";
L["Waiting for quest data..."] = "任務數據等待中...";
L["Vendor"] = "商店";
L["Mission"] = "任務";
L["Achievement"] = "成就";
L["Payment"] = "花費";
L["Reputation"] = "聲望";
L["Type"] = "類型";
L["No description found for..."] = "沒找到說明...";
L["Show FollowerID"] = "顯示追隨者ID";
L[" listed in game (depends on your faction)"] = " 已在遊戲中列出(根據您的陣營)";
L[" hidden followers (Inn recruitement?)"] = "隱藏的追隨者(需要旅店？)";
L[" followers with description"] = " 有說明文字的追隨者";
L[" collected with this character"] = " 此角色已經收集的";
L["Follower ID"] = "追隨者ID";
L["FollowerID"] = "追隨者ID";
L["Show/Hide followerID's in follower list"] = "在追隨者列表中 顯示/隱藏 追隨者的ID";
L["Collected followers"] = "已收集的追隨者";
L["Show/Hide collected and not collectable followers in follower list"] = "在追隨者列表中 顯示/隱藏 已收集跟未收集的追隨者";
L["Commandline options for %s"] = "%s 的指令行選項";
L["Usage: /fli <command>"] = "使用： /fli <指令>";
L["or /followerlocationinfo <command>"] = "或 /followerlocationinfo <指令>";
L["Commands:"] = "指令：";
L["Show/Hide frame."] = "顯示/隱藏框架。";
L["Show/Hide collected followers."] = "顯示/隱藏已收集的追隨者們。";
L["Show/Hide follower ids."] = "顯示/隱藏追隨者ID。";
L["Reset addon settings."] = "重置插件設定。";
L["Print missing data (follower and npc id's)"] = "發送缺少的數據(追隨者與NPC的ID)";
L["Abilities"] = "技能";
L["hidden followers"] = "隱藏的追隨者";
L["Classes & Class speccs"] = "職業與職業專精";
L["Abilities/Counters & Traits"] = "技能/反制與特長";
L["Show/Hide big 3d model viewer"] = "顯示/隱藏巨型3D模型觀察器";
L["Add waypoint to Tom Tom"] = "新增TomTom的路徑點";
L["Can't get achievement data. %d isn't an achievement id?"] = "無法獲得成就數據。 %d不是一個成就ID嗎？";
L["Quest giver"] = "任務給予者";
L["Vendor for "] = "商店在";
L["Show/Hide follower list"] = "顯示/隱藏 追隨者列表";
L["Show/Hide minimap button"] = "顯示/隱藏 小地圖按鈕";
L["~ development commands ~"] = "~ 開發命令 ~";
L["Abilities (page %d)"] = "技能 (頁 %d)";
L["Filter 1"] = "過濾 1";
L["Filter 2"] = "過濾 2";
L["Followers"] = "追隨者";
L["Basic abilities/counters and traits"] = "基礎技能/反制與特長";
L["Click to expand/collapse"] = "點擊來展開/收起";
L["This follower is member of a collect group and already collected."] = "此追隨者是收藏組的成員之一，並且已經收藏了。";
L["This follower is member of a collect group and is no longer collectable."] = "此追隨者是收藏組的成員之一，但不再具有收藏價值。";
L["This follower is member of a collect group and is collectable."] = "此追隨者是收藏組的成員之一，具有收藏價值。";
L["In group with:"] = "在何群組：";
L["Collects localized follower names from one faction. It is recommented to use it on both factions. The character must be level 90 or higher."] = "從一個陣營蒐集本地化的追隨者名稱。建議分別在兩個陣營都使用。此角色必須要至少90級或更高。";
L["Deletes collected localized follower names"] = "刪除已蒐集的本地化追隨者名稱";
L["URL"] = "網址";
L["Counters"] = "反制";
L["Toggle FollowerLocationInfo Display"] = "切換FollowerLocationInfo是否顯示";
L["Choose"] = "選擇";
L["Classes"] = "職業";
L["Class speccs"] = "職業專精";
L["Traits"] = "特長";
L["Usage"] = "使用方法";
L["Select a follower to see the description..."] = "點選一個追隨者以查看說明...";
L["Version"] = "版本";
L["slash commands"] = "指令";
L["Msg from Dev"] = "開發訊息";

--[[ requirements ]]
L["Lumber mill"] = "鋸木廠";
L["Lumber mill (Level 2)"] = "鋸木廠 等級2";
L["Lumber mill (Level 3)"] = "鋸木廠 等級3";
L["Fishing Shack 3"] = "釣屋 等級3";
L["Fishing skill 700"] = "釣魚等級 700";
L["Lunarfall Inn"] = "落月旅店";
L["Frostwall Tavern"] = "霜牆酒館";
L["Brawler's Guild Rank 5"] = "鬥陣俱樂部 階級5";
L["Trading Post"] = "貿易站";
L["Trading Post 2"] = "貿易站 等級2";
L["Arcane sanctum in talador outpost"] = "塔拉多爾哨站選擇奧秘聖所";
L["Sparring Arena in gorgrond outpost"] = "格古隆德哨站選擇搏擊競技場";
L["Brewery in Spikes of Arak outpost"] = "阿拉卡哨站選擇釀酒廠";
L["Lumber mill in gorgrond outpost"] = "格古隆德哨站選擇鋸木廠";
L["Dungeon type: Herioc, coordinations unknown..."] = "地城難度: 英雄，座標未知...";
L["Abu'Gar's Favorite Lure"] = "阿布加爾最愛的魚餌";
L["Abu'Gar's Vitality"] = "阿布加爾的活力";
L["Abu'Gar's Finest Reel"] = "阿布加爾的精緻線輪";
L["Abu'gar himself"] = "阿布加爾本人";

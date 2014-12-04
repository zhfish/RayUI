SLASH_FOLLOWEREXPORT1, SLASH_FOLLOWEREXPORT2 = '/followerexport', '/fe'; -- 3.
function SlashCmdList.FOLLOWEREXPORT(msg, editbox) -- 4.
	GetFollowerString();
	FollowExportFrame:Show();
end
function GetFollowerString()
	local FollowerString = "姓名,职业,品质,等级,装等,激活,技能1,技能2,特长1,特长2,特长3".."|n";
	local followersList = C_Garrison.GetFollowers();
	for i = 1, #followersList do
		if(followersList[i].isCollected) then
			local str=""--..followersList[i].followerID;
			str=str..followersList[i].name;
			str=str..","..followersList[i].className;
			str=str..","..followersList[i].quality;
			str=str..","..followersList[i].level;
			str=str..","..(followersList[i].iLevel or "");
			if followersList[i].status~=GARRISON_FOLLOWER_INACTIVE then
				str=str..",";
			else
				str=str..",未激活";
			end
			local followerAbilities = C_Garrison.GetFollowerAbilities(followersList[i].followerID)
			local size=0;
			for a = 1, #followerAbilities do
				local ability = followerAbilities[a];
				if ( not ability.isTrait ) then
					for id, counter in pairs(ability.counters) do
						str=str..","..counter.name;
						size=size+1;
					end
				end
			end
			while size<2 do
				str=str..",";
				size=size+1;
			end
			for a = 1, #followerAbilities do
				local ability = followerAbilities[a];
				if (ability.isTrait ) then
					str=str..","..ability.name;
				end
			end
			FollowerString=FollowerString..str.."|n";
		end
	end
	parentEditBox:SetText(FollowerString);
end
function ExportFrame_OnLoad(self)
	FollowExportFrame:Hide();
end
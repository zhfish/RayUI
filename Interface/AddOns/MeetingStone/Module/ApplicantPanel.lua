
BuildEnv(...)

ApplicantPanel = Addon:NewModule(CreateFrame('Frame', nil, ManagerPanel), 'ApplicantPanel', 'AceEvent-3.0', 'NetEaseGUI-DropMenu-1.0', 'AceTimer-3.0')


local function _PartySortHandler(applicant)
    return applicant:GetNumMembers() > 1 and format('%08x', applicant:GetID())
end

local APPLICANT_LIST_HEADER = {
    {
        key = 'Icon',
        text = '@',
        style = 'ICON:20:20',
        width = 30,
        iconHandler = function(applicant)
            if applicant:GetRelationship() then
                return [[Interface\AddOns\MeetingStone\Media\Icons]], 0, 0.125, 0, 1
            end
        end
    },
    {
        key = 'Name',
        text = L['角色名'],
        width = 95,
        style = 'LEFT',
        showHandler = function(applicant)
            local color = applicant:GetResult() and RAID_CLASS_COLORS[applicant:GetClass()] or GRAY_FONT_COLOR
            return applicant:GetShortName(), color.r, color.g, color.b
        end
    },
    {
        key = 'Role',
        text = L['职责'],
        width = 52,
        style = Addon:GetClass('RoleItem'),
        formatHandler = function(grid, applicant)
            grid:SetMember(applicant)
        end,
        sortHandler = function(applicant)
            return _PartySortHandler(applicant) or applicant:GetRoleID()
        end
    },
    {
        key = 'Class',
        text = L['职业'],
        width = 40,
        style = 'ICON:18:18',
        iconHandler = function(applicant)
            return [[INTERFACE\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]], CLASS_ICON_TCOORDS[applicant:GetClass()]
        end,
        sortHandler = function(applicant)
            return _PartySortHandler(applicant) or applicant:GetClass()
        end
    },
    {
        key = 'Level',
        text = L['等级'],
        width = 40,
        showHandler = function(applicant)
            local level = applicant:GetLevel()
            if applicant:GetResult() then
                local activity = CreatePanel:IsActivityCreated()
                if activity and activity:GetIsMeetingStone() and (level < activity:GetMinLevel() or level > activity:GetMaxLevel()) then
                    return level, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
                else
                    return level
                end
            else
                return applicant:GetLevel(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            end
        end,
        sortHandler = function(applicant)
            return _PartySortHandler(applicant) or tostring(999 - applicant:GetLevel())
        end
    },
    {
        key = 'ItemLevel',
        text = L['装等'],
        width = 52,
        showHandler = function(applicant)
            if applicant:GetResult() then
                return applicant:GetItemLevel()
            else
                return applicant:GetItemLevel(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            end
        end,
        sortHandler = function(applicant)
            return _PartySortHandler(applicant) or tostring(9999 - applicant:GetItemLevel())
        end
    },
    {
        key = 'PvPRating',
        text = L['PvP'],
        width = 52,
        showHandler = function(applicant)
            local activity = CreatePanel:IsActivityCreated()
            if not activity or not IsHasPVPRating(activity:GetActivityID()) or not activity:GetIsMeetingStone() then
                return ''
            end

            local pvpRating = applicant:GetPvPRating()
            if applicant:GetResult() then
                if pvpRating < activity:GetPvPRating() then
                    return pvpRating, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
                else
                    return pvpRating
                end
            else
                return pvpRating, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            end
        end,
        sortHandler = function(applicant)
            return _PartySortHandler(applicant) or tostring(9999 - applicant:GetPvPRating())
        end
    },
    {
        key = 'Msg',
        text = L['描述'],
        width = 100,
        style = 'LEFT',
        showHandler = function(applicant)
            if applicant:GetResult() then
                return applicant:GetMsg()
            else
                return applicant:GetMsg(), GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b
            end
        end,
    },
    {
        key = 'Option',
        text = L['操作'],
        width = 130,
        class = Addon:GetClass('OperationGrid'),
        formatHandler = function(grid, applicant)
            grid:SetMember(applicant, CreatePanel:GetCurrentActivity():GetActivityID())
        end
    }
}

function ApplicantPanel:OnInitialize()
    self:SetPoint('TOPRIGHT')
    self:SetPoint('BOTTOMRIGHT')
    self:SetPoint('TOPLEFT', CreatePanel, 'TOPRIGHT', 8, 0)

    local ApplicantList = GUI:GetClass('DataGridView'):New(self) do
        ApplicantList:SetAllPoints(true)
        ApplicantList:InitHeader(APPLICANT_LIST_HEADER)
        ApplicantList:SetItemHeight(32)
        ApplicantList:SetItemClass(Addon:GetClass('ApplicantItem'))
        ApplicantList:SetItemSpacing(0)
        ApplicantList:SetHeaderPoint('BOTTOMLEFT', ApplicantList, 'TOPLEFT', -2, 2)
        ApplicantList:SetSingularAdapter(true)
        ApplicantList:SetGroupHandle(function(applicant)
            return applicant:GetID()
        end)
        ApplicantList:SetCallback('OnRoleClick', function(_, _, applicant, role)
            C_LFGList.SetApplicantMemberRole(applicant:GetID(), applicant:GetIndex(), role)
        end)
        ApplicantList:SetCallback('OnInviteClick', function(_, _, applicant)
            self:Invite(applicant:GetID(), applicant:GetNumMembers())
        end)
        ApplicantList:SetCallback('OnDeclineClick', function(_, _, applicant)
            self:Decline(applicant:GetID(), applicant:GetStatus())
        end)
        ApplicantList:SetCallback('OnItemEnter', function(_, _, applicant)
            MainPanel:OpenApplicantTooltip(applicant)
        end)
        ApplicantList:SetCallback('OnItemLeave', function()
            MainPanel:CloseTooltip()
        end)
        ApplicantList:SetCallback('OnItemMenu', function(_, button, applicant)
            self:ToggleEventMenu(button, applicant)
        end)
        ApplicantList:SetCallback('OnItemGrouped', function(_, button, applicant, isSingularLine, endButton, startButton)
            if not endButton then
                button:SetBackground(startButton == button)
            else
                button:SetAlpha(isSingularLine and 0.1 or 0.05, endButton)
            end
        end)
    end

    local AutoInvite = GUI:GetClass('CheckBox'):New(self) do
        AutoInvite:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', -60, -7)
        AutoInvite:SetText(L['自动邀请'])
        AutoInvite:SetSize(20, 20)
        AutoInvite:SetScript('OnClick', function(AutoInvite)
            local checked = AutoInvite:GetChecked()
            self:SetAutoInvite(checked)
        end)
        AutoInvite:SetScript('OnDisable', function(AutoInvite)
            self:SetAutoInvite(false)
        end)
    end

    self.ApplicantList = ApplicantList
    self.AutoInvite = AutoInvite

    self:RegisterEvent('LFG_LIST_APPLICANT_UPDATED', 'UpdateApplicantsList')
    self:RegisterEvent('LFG_LIST_APPLICANT_LIST_UPDATED', 'UpdateApplicantsList')

    self:RegisterMessage('MEETINGSTONE_PERMISSION_UPDATE', function(_, canCreate, isManager)
        self.AutoInvite:SetEnabled(C_LFGList.GetActiveEntryInfo() and (canCreate or isManager))
    end)

    self:SetScript('OnShow', function()
        DataBroker:SetMinimapButtonGlow(false)
    end)
end

function ApplicantPanel:UpdateApplicantsList()
    local applicants = C_LFGList.GetApplicants()

    if applicants then
        self:UpdateList(applicants)
    end
end

local function _SortApplicants(applicant1, applicant2)
    if applicant1:GetIsNew() ~= applicant2:GetIsNew() then
        return applicant2:GetIsNew()
    end

    return applicant1:GetOrderID() < applicant2:GetOrderID()
end

function ApplicantPanel:UpdateList(applicants)
    local list = {}
    local _, activityID = C_LFGList.GetActiveEntryInfo()

    for i, v in ipairs(applicants) do
        local id, status, pendingStatus, numMembers, isNew, msg, orderID = C_LFGList.GetApplicantInfo(v)
        for i = 1, numMembers do
            tinsert(list, Applicant:New(i, id, status, pendingStatus, numMembers, isNew, msg, orderID, activityID))
        end
    end

    table.sort(list, _SortApplicants)
    self.ApplicantList:SetItemList(list)
    self.ApplicantList:Refresh()
end

function ApplicantPanel:Invite(id, numMembers)
    if not IsInRaid(LE_PARTY_CATEGORY_HOME) and
        GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) + numMembers + C_LFGList.GetNumInvitedApplicantMembers() > MAX_PARTY_MEMBERS + 1 then
        local dialog = StaticPopup_Show('LFG_LIST_INVITING_CONVERT_TO_RAID')
        if dialog then
            dialog.data = id
        end
    else
        C_LFGList.InviteApplicant(id)
        return true
    end
end

function ApplicantPanel:Decline(id, status)
    if status ~= 'applied' and status ~= 'invited' then
        C_LFGList.RemoveApplicant(id)
    else
        C_LFGList.DeclineApplicant(id)
    end
end

function ApplicantPanel:ToggleEventMenu(button, applicant)
    local name = applicant:GetName()

    self:ToggleMenu(button, {
        {
            text = name,
            isTitle = true,
        },
        {
            text = WHISPER,
            func = function()
                ChatFrame_SendTell(name)
            end,
            disabled = not name or not applicant:GetResult(),
        },
        {
            text = LFG_LIST_REPORT_FOR,
            hasArrow = true,
            menuTable = {
                {
                    text = LFG_LIST_BAD_PLAYER_NAME,
                    func = function()
                        C_LFGList.ReportApplicant(applicant:GetID(), 'badplayername', applicant:GetIndex())
                    end,
                },
                {
                    text = LFG_LIST_BAD_DESCRIPTION,
                    func = function()
                        C_LFGList.ReportApplicant(applicant:GetID(), 'lfglistappcomment')
                    end,
                    disabled = applicant:GetMsg() == '',
                },
            },
        },
        {
            text = IGNORE_PLAYER,
            func = function()
                AddIgnore(name)
                C_LFGList.DeclineApplicant(applicant:GetID())
            end,
            disabled = not name,
        },
        {
            text = CANCEL,
        },
    }, 'cursor')
end

function ApplicantPanel:SetAutoInvite(flag)
    self:CancelTimer(self._autoInviteTimer)

    if flag then
        self._autoInviteTimer = self:ScheduleRepeatingTimer('StartInvite', 3)
        local maxPlayers = select('8', C_LFGList.GetActivityInfo(CreatePanel:GetCurrentActivity():GetActivityID()))
        maxPlayers = maxPlayers == 0 and 40 or maxPlayers
        if not IsInRaid(LE_PARTY_CATEGORY_HOME) and maxPlayers > 5 then
            ConvertToRaid()
        end
    end

    debug('AutoInvite: ' .. (flag and 'start' or 'stop'))
end

function ApplicantPanel:CanInvite(applicant)
    local status = applicant:GetStatus()
    local numMembers = applicant:GetNumMembers()

    local numAllowed = select(ACTIVITY_RETURN_VALUES.maxPlayers, C_LFGList.GetActivityInfo(CreatePanel:GetCurrentActivity():GetActivityID()))
    if numAllowed == 0 then
        numAllowed = MAX_RAID_MEMBERS
    end

    local currentCount = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME)
    local numInvited = C_LFGList.GetNumInvitedApplicantMembers()

    if numMembers + currentCount > numAllowed then
        return
    elseif numMembers + currentCount + numInvited > numAllowed then
        return
    elseif status == 'applied' then
        return true
    end
end

function ApplicantPanel:StartInvite()
    local list = self.ApplicantList:GetItemList()
    for i, v in ipairs(list) do
        if self:CanInvite(v) then
            if self:Invite(v:GetID(), v:GetNumMembers()) then
                debug('invite: ' .. v:GetName() .. ' ' .. v:GetLocalizedClass())
            end
            break
        end
    end
end

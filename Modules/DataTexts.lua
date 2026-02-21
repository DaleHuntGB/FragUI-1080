local _, FUI = ...

local function FetchOnlineFriends()
    local numOfOnlineFriends = 0

    for i = 1, select(2, BNGetNumFriends()) do
        local accountInfo = C_BattleNet.GetAccountInfoByID(i)
        if accountInfo then
            local gameAccountInfo = accountInfo.gameAccountInfo
            if gameAccountInfo and gameAccountInfo.isOnline then
                numOfOnlineFriends = numOfOnlineFriends + 1
            end
        end
    end

   return string.format("|c%sFriends|r: %d", FUI.PLAYER_CLASS_COLOR_HEX, numOfOnlineFriends)
end

local function FetchFriendData()
    local friendData = {}

    for i = 1, select(2, BNGetNumFriends()) do
        local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
        if accountInfo and accountInfo.gameAccountInfo then
            local accountName = accountInfo.accountName
            local gameAccountInfo = accountInfo.gameAccountInfo
            if gameAccountInfo.isOnline and gameAccountInfo.clientProgram == BNET_CLIENT_WOW and gameAccountInfo.wowProjectID == WOW_PROJECT_MAINLINE then
                local characterName = gameAccountInfo.characterName
                local characterLevel = gameAccountInfo.characterLevel
                local characterClass = gameAccountInfo.className
                local characterFaction = gameAccountInfo.factionName

                table.insert(friendData,
                    string.format(
                        "|c%s%s|r [|c%s%s|r - L|cFFFFCC00%d|r] - %s",
                        FUI:FetchClassColour(characterClass),
                        accountName,
                        FUI:FetchClassColour(characterClass),
                        characterName,
                        characterLevel,
                        characterFaction
                    )
                )
            end
        end
    end

    return table.concat(friendData, "\n")
end


local function FetchOnlineGuildMembers()
    local _, onlineGuildMembers = GetNumGuildMembers()
    return string.format("|c%sGuild|r: %d", FUI.PLAYER_CLASS_COLOR_HEX, onlineGuildMembers)
end

local function FetchGuildData()
    local guildData = {}
    local _, onlineGuildMembers = GetNumGuildMembers()
    for i = 1, onlineGuildMembers do
        local unitName, unitRank, _, unitLevel, unitClass, unitZone = GetGuildRosterInfo(i)
        if unitName then
            table.insert(guildData, string.format("|c%s%s|r [L|c%s%d|r] - %s", FUI:FetchClassColour(unitClass), Ambiguate(unitName, "short"), "FFFFCC00", unitLevel, unitZone))
        end
    end
    return table.concat(guildData, "\n")
end

local function CreateDataTextFrame(layoutPosition, frameW, frameH, textFunction, tooltipFunction, onClickFunction)
    local DataTextFrame = CreateFrame("Frame", "FragUI_GuildDataText", UIParent, "BackdropTemplate")
    DataTextFrame:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, bgFile = "Interface\\Buttons\\WHITE8X8", insets = { left = 0, right = 0, top = 0, bottom = 0 } })
    DataTextFrame:SetBackdropColor(26/255, 26/255, 26/255, 1)
    DataTextFrame:SetBackdropBorderColor(0, 0, 0, 1)
    DataTextFrame:SetPoint(unpack(layoutPosition))
    DataTextFrame:SetSize(frameW, frameH)


    DataTextFrame.Text = DataTextFrame:CreateFontString(nil, "OVERLAY")
    DataTextFrame.Text:SetFont("Fonts\\FRIZQT__.TTF", 11, FUI.Media.FontFlag)
    DataTextFrame.Text:SetPoint("CENTER", DataTextFrame, "CENTER", 0, 0)
    DataTextFrame.Text:SetText(textFunction())

    DataTextFrame.Hover = CreateFrame("Frame", nil, DataTextFrame, "BackdropTemplate")
    DataTextFrame.Hover:SetPoint("TOPLEFT", DataTextFrame, "TOPLEFT", 1, -1)
    DataTextFrame.Hover:SetPoint("BOTTOMRIGHT", DataTextFrame, "BOTTOMRIGHT", -1, 1)
    DataTextFrame.Hover:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, bgFile = "Interface\\Buttons\\WHITE8X8", insets = { left = 0, right = 0, top = 0, bottom = 0 } })
    DataTextFrame.Hover:SetBackdropColor(0, 0, 0, 0)
    DataTextFrame.Hover:SetBackdropBorderColor(0, 0, 0, 0)
    DataTextFrame.Hover:SetPoint("CENTER", DataTextFrame, "CENTER", 0, 0)

    DataTextFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 1, -21)
        GameTooltip:AddLine(tooltipFunction(), 1, 1, 1)
        GameTooltip:Show()
        DataTextFrame.Hover:SetBackdropBorderColor(FUI.PLAYER_CLASS_COLOR.r, FUI.PLAYER_CLASS_COLOR.g, FUI.PLAYER_CLASS_COLOR.b, 1.0)
    end)

    DataTextFrame:SetScript("OnLeave", function() GameTooltip:Hide() DataTextFrame.Hover:SetBackdropBorderColor(0, 0, 0, 0) end)

    DataTextFrame:SetScript("OnMouseDown", function(self, button) if button == "LeftButton" and onClickFunction then onClickFunction() end end)

    DataTextFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    DataTextFrame:RegisterEvent("BN_FRIEND_ACCOUNT_ONLINE")
    DataTextFrame:RegisterEvent("BN_FRIEND_ACCOUNT_OFFLINE")
    DataTextFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
    DataTextFrame:SetScript("OnEvent", function() DataTextFrame.Text:SetText(textFunction()) end)

    return DataTextFrame
end

function FUI:SetupDataTexts()
    FUI.GuildDataText = CreateDataTextFrame({"TOPLEFT", Minimap, "BOTTOMLEFT", -1, 0}, 92, 20, FetchOnlineGuildMembers, FetchGuildData, function() ToggleGuildFrame() end)
    FUI.FriendsDataText = CreateDataTextFrame({"TOPRIGHT", Minimap, "BOTTOMRIGHT", 1, 0}, 91, 20, FetchOnlineFriends, FetchFriendData, function() ToggleFriendsFrame() end)
    if not FUI.db.global.QualityOfLife.DataTexts then FUI.FriendsDataText:Hide() FUI.GuildDataText:Hide() end
end

function FUI:UpdateDataTexts()
    local DataTextDB = FUI.db.global.QualityOfLife.DataTexts
    if DataTextDB then
        FUI.FriendsDataText:Show()
        FUI.GuildDataText:Show()
    else
        FUI.FriendsDataText:Hide()
        FUI.GuildDataText:Hide()
    end
end
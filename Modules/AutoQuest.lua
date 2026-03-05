local _, FUI = ...

local deferred = {
    acceptQuest = false,
    completeQuest = false,
    getQuestReward = false,
}

local function ResetDeferred()
    deferred.acceptQuest = false
    deferred.completeQuest = false
    deferred.getQuestReward = false
end

local function IsAutoQuestEnabled()
    return FUI.db and FUI.db.global and FUI.db.global.QualityOfLife and FUI.db.global.QualityOfLife.AutoQuest
end

local function HandleModernGossip()
    if not C_GossipInfo then
        return false
    end

    if C_GossipInfo.GetActiveQuests and C_GossipInfo.SelectActiveQuest then
        for _, questInfo in ipairs(C_GossipInfo.GetActiveQuests() or {}) do
            if questInfo.isComplete and questInfo.questID then
                C_GossipInfo.SelectActiveQuest(questInfo.questID)
                return true
            end
        end
    end

    if C_GossipInfo.GetAvailableQuests and C_GossipInfo.SelectAvailableQuest then
        for _, questInfo in ipairs(C_GossipInfo.GetAvailableQuests() or {}) do
            if questInfo.questID then
                C_GossipInfo.SelectAvailableQuest(questInfo.questID)
                return true
            end
        end
    end

    return false
end

local function HandleLegacyGossip()
    if GetNumActiveQuests and GetActiveTitle and SelectActiveQuest then
        for index = 1, (GetNumActiveQuests() or 0) do
            local _, isComplete = GetActiveTitle(index)
            if isComplete then
                SelectActiveQuest(index)
                return true
            end
        end
    end

    if GetNumAvailableQuests and SelectAvailableQuest then
        for index = 1, (GetNumAvailableQuests() or 0) do
            SelectAvailableQuest(index)
            return true
        end
    end

    return false
end

local function HandleGossipShow()
    if HandleModernGossip() then
        return
    end

    HandleLegacyGossip()
end

local function HandleQuestDetail()
    if QuestGetAutoAccept() then
        CloseQuest()
        return
    end

    if InCombatLockdown() then
        deferred.acceptQuest = true
        return
    end

    AcceptQuest()
end

local function HandleQuestProgress()
    if not IsQuestCompletable() then
        return
    end

    if InCombatLockdown() then
        deferred.completeQuest = true
        return
    end

    CompleteQuest()
end

local function HandleQuestComplete()
    if GetNumQuestChoices() ~= 0 then
        return
    end

    if InCombatLockdown() then
        deferred.getQuestReward = true
        return
    end

    GetQuestReward(1)
end

local function HandleDeferredActions()
    if deferred.acceptQuest and QuestFrame and QuestFrame:IsShown() then
        if not InCombatLockdown() and not QuestGetAutoAccept() then
            deferred.acceptQuest = false
            AcceptQuest()
        end
    end

    if deferred.completeQuest and QuestFrame and QuestFrame:IsShown() then
        if not InCombatLockdown() and IsQuestCompletable() then
            deferred.completeQuest = false
            CompleteQuest()
        end
    end

    if deferred.getQuestReward and QuestFrame and QuestFrame:IsShown() then
        if not InCombatLockdown() and GetNumQuestChoices() == 0 then
            deferred.getQuestReward = false
            GetQuestReward(1)
        end
    end
end

local function RegisterAutoQuestEvents(frame)
    frame:RegisterEvent("GOSSIP_SHOW")
    frame:RegisterEvent("QUEST_GREETING")
    frame:RegisterEvent("QUEST_DETAIL")
    frame:RegisterEvent("QUEST_PROGRESS")
    frame:RegisterEvent("QUEST_COMPLETE")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function FUI:SetupAutoQuest()
    if FUI.AutoQuestFrame then
        FUI:UpdateAutoQuest()
        return
    end

    local autoQuestFrame = CreateFrame("Frame")
    autoQuestFrame:SetScript("OnEvent", function(_, event)
        if not IsAutoQuestEnabled() then
            return
        end

        if event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then
            HandleGossipShow()
        elseif event == "QUEST_DETAIL" then
            HandleQuestDetail()
        elseif event == "QUEST_PROGRESS" then
            HandleQuestProgress()
        elseif event == "QUEST_COMPLETE" then
            HandleQuestComplete()
        elseif event == "PLAYER_REGEN_ENABLED" then
            HandleDeferredActions()
        end
    end)

    FUI.AutoQuestFrame = autoQuestFrame
    FUI:UpdateAutoQuest()
end

function FUI:UpdateAutoQuest()
    if not FUI.AutoQuestFrame then
        return
    end

    FUI.AutoQuestFrame:UnregisterAllEvents()
    if IsAutoQuestEnabled() then
        RegisterAutoQuestEvents(FUI.AutoQuestFrame)
    else
        ResetDeferred()
    end
end

local _, FUI = ...

local function FormatXP(value)
    return AbbreviateLargeNumbers(value or 0)
end

local function IsQuestReadyForTurnIn(questID)
    if not questID then
        return false
    end

    local function NormalizeCompletionValue(value)
        return value == true or value == 1
    end

    if C_QuestLog and C_QuestLog.IsComplete then
        local isComplete = C_QuestLog.IsComplete(questID)
        if isComplete == nil then
            return false
        end
        return NormalizeCompletionValue(isComplete)
    end

    if IsQuestComplete then
        local isComplete = IsQuestComplete(questID)
        return NormalizeCompletionValue(isComplete)
    end

    return false
end

local function GetCompletedQuestXP()
    if not C_QuestLog or not C_QuestLog.GetNumQuestLogEntries or not C_QuestLog.GetInfo or not GetQuestLogRewardXP then
        return 0
    end

    local totalQuestXP = 0
    local numEntries = C_QuestLog.GetNumQuestLogEntries() or 0

    for questLogIndex = 1, numEntries do
        local questInfo = C_QuestLog.GetInfo(questLogIndex)
        if questInfo and not questInfo.isHeader and not questInfo.isHidden and IsQuestReadyForTurnIn(questInfo.questID) then
            totalQuestXP = totalQuestXP + (GetQuestLogRewardXP(questInfo.questID) or 0)
        end
    end

    return totalQuestXP
end

local function CanShowExperienceBar()
    if not FUI.db.global.QualityOfLife.ExperienceBar then
        return false
    end

    return UnitLevel("player") < GetMaxPlayerLevel()
end

local function UpdateExperienceBar(experienceBar)
    if not CanShowExperienceBar() then experienceBar:Hide() return end

    local currentXP = UnitXP("player") or 0
    local maxXP = UnitXPMax("player") or 1
    local percentXP = (currentXP / maxXP) * 100
    local restedXP = GetXPExhaustion() or 0
    local restedXPValue = math.min(restedXP, math.max(0, maxXP - currentXP))
    local completedQuestXP = GetCompletedQuestXP()
    local completedQuestXPValue = math.min(completedQuestXP, math.max(0, maxXP - currentXP - restedXPValue))
    local unitLevel = UnitLevel("player") or 0

    experienceBar.RestedStatusBar:SetMinMaxValues(0, maxXP)
    if restedXPValue > 0 then
        experienceBar.RestedStatusBar:SetValue(currentXP + restedXPValue)
        experienceBar.RestedStatusBar:Show()
    else
        experienceBar.RestedStatusBar:Hide()
    end

    experienceBar.CompletedQuestStatusBar:SetMinMaxValues(0, maxXP)
    if completedQuestXPValue > 0 then
        experienceBar.CompletedQuestStatusBar:SetValue(currentXP + restedXPValue + completedQuestXPValue)
        experienceBar.CompletedQuestText:SetFormattedText("Completed: |cFF40FF40%s|r", FormatXP(completedQuestXPValue))
        experienceBar.CompletedQuestStatusBar:Show()
    else
        experienceBar.CompletedQuestStatusBar:Hide()
    end

    experienceBar.StatusBar:SetMinMaxValues(0, maxXP)
    experienceBar.StatusBar:SetValue(currentXP)

    experienceBar.LevelText:SetFormattedText("Level: %d", unitLevel)
    experienceBar.ExperienceText:SetFormattedText("Current: %s / %s (%.0f%%)", FormatXP(currentXP), FormatXP(maxXP), percentXP)

    experienceBar:Show()
end

function FUI:SetupExperienceBar()
    if FUI.ExperienceBar then UpdateExperienceBar(FUI.ExperienceBar) return end

    local experienceBar = CreateFrame("Frame", "FUI_ExperienceBar", UIParent, "BackdropTemplate")
    experienceBar:SetSize(300, 24)
    experienceBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 125)
    experienceBar:SetFrameStrata("MEDIUM")
    experienceBar:SetBackdrop(FUI.Backdrop)
    experienceBar:SetBackdropColor(26 / 255, 26 / 255, 26 / 255, 1)
    experienceBar:SetBackdropBorderColor(0, 0, 0, 1)
    experienceBar:EnableMouse(true)

    experienceBar.Background = experienceBar:CreateTexture(nil, "BACKGROUND")
    experienceBar.Background:SetPoint("TOPLEFT", experienceBar, "TOPLEFT", 1, -1)
    experienceBar.Background:SetPoint("BOTTOMRIGHT", experienceBar, "BOTTOMRIGHT", -1, 1)
    experienceBar.Background:SetColorTexture(0, 0, 0, 0.35)

    experienceBar.StatusBar = CreateFrame("StatusBar", nil, experienceBar)
    experienceBar.StatusBar:SetPoint("TOPLEFT", experienceBar, "TOPLEFT", 1, -1)
    experienceBar.StatusBar:SetPoint("BOTTOMRIGHT", experienceBar, "BOTTOMRIGHT", -1, 1)
    experienceBar.StatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    experienceBar.StatusBar:SetStatusBarColor(64 / 255, 128 / 255, 255 / 255, 1) -- #4080FF
    experienceBar.StatusBar:SetFrameLevel(experienceBar:GetFrameLevel() + 3)

    experienceBar.RestedStatusBar = CreateFrame("StatusBar", nil, experienceBar)
    experienceBar.RestedStatusBar:SetPoint("TOPLEFT", experienceBar.StatusBar, "TOPLEFT", 0, 0)
    experienceBar.RestedStatusBar:SetPoint("BOTTOMRIGHT", experienceBar.StatusBar, "BOTTOMRIGHT", 0, 0)
    experienceBar.RestedStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    experienceBar.RestedStatusBar:SetStatusBarColor(128 / 255, 64 / 255, 255 / 255, 1) -- #8040FF
    experienceBar.RestedStatusBar:SetFrameLevel(experienceBar:GetFrameLevel() + 2)
    experienceBar.RestedStatusBar:Hide()

    experienceBar.CompletedQuestStatusBar = CreateFrame("StatusBar", nil, experienceBar)
    experienceBar.CompletedQuestStatusBar:SetPoint("TOPLEFT", experienceBar.StatusBar, "TOPLEFT", 0, 0)
    experienceBar.CompletedQuestStatusBar:SetPoint("BOTTOMRIGHT", experienceBar.StatusBar, "BOTTOMRIGHT", 0, 0)
    experienceBar.CompletedQuestStatusBar:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
    experienceBar.CompletedQuestStatusBar:SetStatusBarColor(64 / 255, 255 / 255, 64 / 255, 1) -- #40FF40
    experienceBar.CompletedQuestStatusBar:SetFrameLevel(experienceBar:GetFrameLevel() + 1)
    experienceBar.CompletedQuestStatusBar:Hide()

    experienceBar.LevelText = experienceBar.StatusBar:CreateFontString(nil, "OVERLAY")
    experienceBar.LevelText:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
    experienceBar.LevelText:SetPoint("LEFT", experienceBar.StatusBar, "LEFT", 3, 0)
    experienceBar.LevelText:SetJustifyH("LEFT")

    experienceBar.ExperienceText = experienceBar.StatusBar:CreateFontString(nil, "OVERLAY")
    experienceBar.ExperienceText:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
    experienceBar.ExperienceText:SetPoint("RIGHT", experienceBar.StatusBar, "TOPRIGHT", -3, 0)
    experienceBar.ExperienceText:SetJustifyH("RIGHT")

    experienceBar.CompletedQuestText = experienceBar.StatusBar:CreateFontString(nil, "OVERLAY")
    experienceBar.CompletedQuestText:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
    experienceBar.CompletedQuestText:SetPoint("RIGHT", experienceBar.StatusBar, "BOTTOMRIGHT", -3, 0)
    experienceBar.CompletedQuestText:SetJustifyH("RIGHT")

    experienceBar:RegisterEvent("PLAYER_ENTERING_WORLD")
    experienceBar:RegisterEvent("PLAYER_LEVEL_UP")
    experienceBar:RegisterEvent("PLAYER_XP_UPDATE")
    experienceBar:RegisterEvent("UPDATE_EXHAUSTION")
    experienceBar:RegisterEvent("ENABLE_XP_GAIN")
    experienceBar:RegisterEvent("DISABLE_XP_GAIN")
    experienceBar:RegisterEvent("QUEST_LOG_UPDATE")
    experienceBar:RegisterEvent("QUEST_TURNED_IN")

    experienceBar:SetScript("OnEvent", function(self, event, unit) if event == "PLAYER_XP_UPDATE" and unit and unit ~= "player" then return end UpdateExperienceBar(self) end)
    experienceBar:HookScript("OnSizeChanged", function(self) UpdateExperienceBar(self) end)


    FUI.ExperienceBar = experienceBar
    UpdateExperienceBar(experienceBar)
end

function FUI:UpdateExperienceBar()
    if FUI.ExperienceBar then UpdateExperienceBar(FUI.ExperienceBar) end
end

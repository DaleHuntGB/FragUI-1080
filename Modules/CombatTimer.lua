local _, FUI = ...

local function AnchorCombatTimer(combatTimerFrame)
    local playerFrame = _G["UUF_Player"]
    if not playerFrame then return false end

    combatTimerFrame:ClearAllPoints()
    combatTimerFrame:SetPoint("LEFT", playerFrame, "LEFT", 3, 0)
    combatTimerFrame:UnregisterEvent("ADDON_LOADED")
    return true
end

local function QueueCombatTimerAnchorRetry(combatTimerFrame)
    if combatTimerFrame.retryAnchoring then return end
    local anchorAttempts = 0
    combatTimerFrame.retryAnchoring = C_Timer.NewTicker(0.25, function(anchorTicker)
        anchorAttempts = anchorAttempts + 1
        if AnchorCombatTimer(combatTimerFrame) or anchorAttempts >= 40 then anchorTicker:Cancel() combatTimerFrame.retryAnchoring = nil end
    end)
end

local function StartCombatTimerUpdate(combatTimerFrame, timeElapsed)
    combatTimerFrame.timeElapsed = (combatTimerFrame.timeElapsed or 0) + timeElapsed
    if combatTimerFrame.timeElapsed >= 1 then
        local inCombatTime = GetTime() - combatTimerFrame.combatStartTime
        local minutes = math.floor(inCombatTime / 60)
        local seconds = math.floor(inCombatTime % 60)
        combatTimerFrame.Text:SetText(string.format("%02d:%02d", minutes, seconds))
        combatTimerFrame:SetSize(combatTimerFrame.Text:GetStringWidth(), combatTimerFrame.Text:GetStringHeight())
        combatTimerFrame.timeElapsed = 0
    end
end

local function StopCombatTimer(combatTimerFrame)
    combatTimerFrame:SetScript("OnUpdate", nil)
    combatTimerFrame.combatStartTime = nil
    combatTimerFrame.timeElapsed = 0
    combatTimerFrame.Text:SetText("")
    combatTimerFrame:SetSize(combatTimerFrame.Text:GetStringWidth(), combatTimerFrame.Text:GetStringHeight())
end

local function BeginCombatTimer(combatTimerFrame)
    combatTimerFrame.combatStartTime = GetTime()
    combatTimerFrame.timeElapsed = 0
    combatTimerFrame.Text:SetText("00:00")
    combatTimerFrame:SetSize(combatTimerFrame.Text:GetStringWidth(), combatTimerFrame.Text:GetStringHeight())
    combatTimerFrame:SetScript("OnUpdate", StartCombatTimerUpdate)
end

function FUI:SetupCombatTimer()
    if FUI.CombatTimerFrame then FUI:UpdateCombatTimer() return end

    local CombatTimerFrame = CreateFrame("Frame", "FUICombatTimer", UIParent)
    CombatTimerFrame:SetSize(24, 24)
    if not AnchorCombatTimer(CombatTimerFrame) then CombatTimerFrame:RegisterEvent("ADDON_LOADED") QueueCombatTimerAnchorRetry(CombatTimerFrame) end
    CombatTimerFrame:SetFrameStrata("HIGH")
    CombatTimerFrame:EnableMouse(false)


    CombatTimerFrame.Text = CombatTimerFrame:CreateFontString(nil, "OVERLAY")
    CombatTimerFrame.Text:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
    CombatTimerFrame.Text:SetPoint("LEFT", CombatTimerFrame, "LEFT", 0, 0)
    CombatTimerFrame.Text:SetText("")
    CombatTimerFrame.Text:SetVertexColor(1, 1, 1, 1)
    CombatTimerFrame.Text:SetJustifyH("LEFT")

    CombatTimerFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "ADDON_LOADED" then local addonName = ... if addonName == "UnhaltedUnitFrames" then if not AnchorCombatTimer(self) then QueueCombatTimerAnchorRetry(self) end end return end
        if not FUI.db.global.QualityOfLife.CombatTimer then return end
        if event == "PLAYER_REGEN_DISABLED" then BeginCombatTimer(self) elseif event == "PLAYER_REGEN_ENABLED" then StopCombatTimer(self) end
    end)

    FUI.CombatTimerFrame = CombatTimerFrame
    FUI:UpdateCombatTimer()
end

function FUI:UpdateCombatTimer()
    local QualityOfLifeDB = FUI.db.global.QualityOfLife
    local CombatTimerFrame = FUI.CombatTimerFrame
    if not CombatTimerFrame then
        return
    end

    if not AnchorCombatTimer(CombatTimerFrame) then
        QueueCombatTimerAnchorRetry(CombatTimerFrame)
    end

    CombatTimerFrame.Text:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)

    if QualityOfLifeDB.CombatTimer then
        CombatTimerFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        CombatTimerFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        CombatTimerFrame:SetAlpha(1)

        if InCombatLockdown() then
            if not CombatTimerFrame.combatStartTime then BeginCombatTimer(CombatTimerFrame) end
        else
            StopCombatTimer(CombatTimerFrame)
        end
    else
        CombatTimerFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
        CombatTimerFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        CombatTimerFrame:SetAlpha(0)
        StopCombatTimer(CombatTimerFrame)
    end
end

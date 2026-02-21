local _, FUI = ...

function FUI:SetupCombatAlert()
    local CombatAlertDB = FUI.db.global.CombatAlert
    local CombatAlertFrame = CreateFrame("Frame")
    CombatAlertFrame:EnableMouse(false)

    FUI.CombatAlertFrame = CombatAlertFrame

    CombatAlertFrame.Text = CombatAlertFrame:CreateFontString(nil, "OVERLAY")
    CombatAlertFrame.Text:SetFont(FUI.Media.Font, CombatAlertDB.FontSize, FUI.Media.FontFlag)
    CombatAlertFrame.Text:SetPoint(CombatAlertDB.Layout[1], UIParent,  CombatAlertDB.Layout[2], CombatAlertDB.Layout[3], CombatAlertDB.Layout[4])
    CombatAlertFrame.Text:SetText("")

    CombatAlertFrame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_REGEN_DISABLED" then
            CombatAlertFrame.Text:SetText(CombatAlertDB.Text[1])
            CombatAlertFrame.Text:SetVertexColor(unpack(CombatAlertDB.InCombatColour))
            C_Timer.After(3, function() CombatAlertFrame.Text:SetText("") end)
            CombatAlertFrame:SetAlpha(1)
        elseif event == "PLAYER_REGEN_ENABLED" then
            CombatAlertFrame.Text:SetText(CombatAlertDB.Text[2])
            CombatAlertFrame.Text:SetVertexColor(unpack(CombatAlertDB.OutOfCombatColour))
            C_Timer.After(3, function() CombatAlertFrame.Text:SetText("") end)
            CombatAlertFrame:SetAlpha(1)
        end
    end)

    if CombatAlertDB.Enabled then
        FUI.CombatAlertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        FUI.CombatAlertFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        FUI.CombatAlertFrame:SetAlpha(1)
    end
end

function FUI:UpdateCombatAlert()
    local CombatAlertDB = FUI.db.global.CombatAlert

    if CombatAlertDB.Enabled then
        FUI.CombatAlertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
        FUI.CombatAlertFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        FUI.CombatAlertFrame:SetAlpha(1)
    else
        FUI.CombatAlertFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
        FUI.CombatAlertFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        FUI.CombatAlertFrame:SetAlpha(0)
    end

    FUI.CombatAlertFrame.Text:SetFont(FUI.Media.Font, CombatAlertDB.FontSize, FUI.Media.FontFlag)
    FUI.CombatAlertFrame.Text:ClearAllPoints()
    FUI.CombatAlertFrame.Text:SetPoint(CombatAlertDB.Layout[1], UIParent,  CombatAlertDB.Layout[2], CombatAlertDB.Layout[3], CombatAlertDB.Layout[4])
    FUI.CombatAlertFrame.Text:SetJustifyH(FUI:SetJustification(CombatAlertDB.Layout[1]))

    FUI.CombatAlertFrame.Text:SetText(math.random(1, 2) == 1 and CombatAlertDB.Text[1] or CombatAlertDB.Text[2])
    FUI.CombatAlertFrame.Text:SetVertexColor(unpack(math.random(1, 2) == 1 and CombatAlertDB.InCombatColour or CombatAlertDB.OutOfCombatColour))
end
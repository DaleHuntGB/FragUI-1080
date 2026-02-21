local _, FUI = ...

function FUI:SetupCrosshair()
    local CrosshairDB = FUI.db.global.Crosshair
    local CrosshairFrame = CreateFrame("Frame")
    CrosshairFrame:SetPoint(CrosshairDB.Layout[1], UIParent, CrosshairDB.Layout[2], CrosshairDB.Layout[3], CrosshairDB.Layout[4])
    CrosshairFrame:EnableMouse(false)
    CrosshairFrame:SetSize(CrosshairDB.Size, CrosshairDB.Size)
    CrosshairFrame:SetFrameStrata("HIGH")

    FUI.CrosshairFrame = CrosshairFrame

    CrosshairFrame.Texture = CrosshairFrame:CreateTexture(nil, "BACKGROUND")
    CrosshairFrame.Texture:SetAllPoints()
    CrosshairFrame.Texture:SetTexture(FUI.CROSSHAIR_TEXTURES[CrosshairDB.Texture])
    CrosshairFrame.Texture:SetVertexColor(unpack(CrosshairDB.Colour))

    if CrosshairDB.Enabled then
        if CrosshairDB.ShowInCombatOnly then
            FUI.CrosshairFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
            FUI.CrosshairFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
            FUI.CrosshairFrame:SetScript("OnEvent", function(_, event) if event == "PLAYER_REGEN_DISABLED" and CrosshairDB.Enabled then FUI.CrosshairFrame:SetAlpha(1) elseif event == "PLAYER_REGEN_ENABLED" then FUI.CrosshairFrame:SetAlpha(0) end end)
            FUI.CrosshairFrame:SetAlpha(0)
        elseif not CrosshairDB.ShowInCombatOnly then
            FUI.CrosshairFrame:SetScript("OnEvent", nil)
            FUI.CrosshairFrame:SetAlpha(1)
        end
    else
        FUI.CrosshairFrame:SetAlpha(0)
    end

    CrosshairFrame:Show()
end

function FUI:UpdateCrosshair()
    local CrosshairDB = FUI.db.global.Crosshair

    FUI.CrosshairFrame:ClearAllPoints()
    FUI.CrosshairFrame:SetPoint(CrosshairDB.Layout[1], UIParent, CrosshairDB.Layout[2], CrosshairDB.Layout[3], CrosshairDB.Layout[4])
    FUI.CrosshairFrame:SetSize(CrosshairDB.Size, CrosshairDB.Size)
    FUI.CrosshairFrame.Texture:SetTexture(FUI.CROSSHAIR_TEXTURES[CrosshairDB.Texture])
    FUI.CrosshairFrame.Texture:SetVertexColor(unpack(CrosshairDB.Colour))

    if CrosshairDB.Enabled then
        if CrosshairDB.ShowInCombatOnly then
            FUI.CrosshairFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
            FUI.CrosshairFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
            FUI.CrosshairFrame:SetScript("OnEvent", function(_, event) if event == "PLAYER_REGEN_DISABLED" and CrosshairDB.Enabled then FUI.CrosshairFrame:SetAlpha(1) elseif event == "PLAYER_REGEN_ENABLED" then FUI.CrosshairFrame:SetAlpha(0) end end)
            FUI.CrosshairFrame:SetAlpha(0)
        elseif not CrosshairDB.ShowInCombatOnly then
            FUI.CrosshairFrame:SetScript("OnEvent", nil)
            FUI.CrosshairFrame:SetAlpha(1)
        end
    else
        FUI.CrosshairFrame:SetAlpha(0)
    end

    FUI.CrosshairFrame:Show()
end
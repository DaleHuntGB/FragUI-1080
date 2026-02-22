local _, FUI = ...

function FUI:SetupMouseCursor()
    if not FUI.db.global.MouseCursor.Enabled then return end
    local MouseCursorDB = FUI.db.global.MouseCursor
    local MouseTexture = CreateFrame("Frame", "FUI_MouseCursor", UIParent)
    MouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", 0, 0)
    MouseTexture:SetSize(90, 90)

    MouseTexture.Texture = MouseTexture:CreateTexture(nil, "OVERLAY")
    MouseTexture.Texture:SetAllPoints()
    MouseTexture.Texture:SetAtlas(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])

    MouseTexture:SetScript("OnUpdate", function(mouseTexture) local mouseX, mouseY = GetCursorPosition() local uiScale = UIParent:GetEffectiveScale() mouseTexture:ClearAllPoints() mouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", mouseX / uiScale + 13, mouseY / uiScale - 13) end)

    FUI.MouseCursor = MouseTexture

    return MouseTexture
end

function FUI:UpdateMouseCursor()
    local MouseCursorDB = FUI.db.global.MouseCursor
    if FUI.MouseCursor then
        if MouseCursorDB.Enabled then
            FUI.MouseCursor.Texture:SetAtlas(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])
            FUI.MouseCursor:SetSize(90, 90)
            FUI.MouseCursor:SetScript("OnUpdate", function(mouseTexture) local mouseX, mouseY = GetCursorPosition() local uiScale = UIParent:GetEffectiveScale() mouseTexture:ClearAllPoints() mouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", mouseX / uiScale + 13, mouseY / uiScale - 13) end)
            FUI.MouseCursor:Show()
        else
            FUI.MouseCursor:Hide()
            FUI.MouseCursor:SetScript("OnUpdate", nil)
        end
    end
end
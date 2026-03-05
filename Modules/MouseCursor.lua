local _, FUI = ...

local CircleMouseCursors = {
    ["Cursor 03"] = true,
    ["Cursor 04"] = true,
    ["Cursor 05"] = true,
    ["Cursor 06"] = true,
}

function FUI:SetupMouseCursor()
    local MouseCursorDB = FUI.db.global.MouseCursor
    local MouseTexture = CreateFrame("Frame", "FUI_MouseCursor", UIParent)
    MouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", 0, 0)

    MouseTexture.Texture = MouseTexture:CreateTexture(nil, "OVERLAY")
    MouseTexture.Texture:SetAllPoints()

    if CircleMouseCursors[MouseCursorDB.Texture] then
        MouseTexture.Texture:SetTexture(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])
        MouseTexture:SetSize(32, 32)
    else
        MouseTexture.Texture:SetAtlas(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])
        MouseTexture:SetSize(90, 90)
    end

    if FUI.db.global.MouseCursor.Enabled then
        local xOffset = CircleMouseCursors[MouseCursorDB.Texture] and 0 or 13
        local yOffset = CircleMouseCursors[MouseCursorDB.Texture] and 0 or -13
        MouseTexture:SetScript("OnUpdate", function(mouseTexture) local mouseX, mouseY = GetCursorPosition() local uiScale = UIParent:GetEffectiveScale() mouseTexture:ClearAllPoints() mouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", mouseX / uiScale + xOffset, mouseY / uiScale + yOffset) end)
    else
        MouseTexture:Hide()
    end

    FUI.MouseCursor = MouseTexture

    return MouseTexture
end

function FUI:UpdateMouseCursor()
    local MouseCursorDB = FUI.db.global.MouseCursor
    if FUI.MouseCursor then
        if MouseCursorDB.Enabled then
            if CircleMouseCursors[MouseCursorDB.Texture] then
                FUI.MouseCursor.Texture:SetTexture(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])
                FUI.MouseCursor:SetSize(32, 32)
            else
                FUI.MouseCursor.Texture:SetAtlas(FUI.MOUSE_CURSOR_TEXTURES[MouseCursorDB.Texture])
                FUI.MouseCursor:SetSize(90, 90)
            end
            local xOffset = CircleMouseCursors[MouseCursorDB.Texture] and 0 or 13
            local yOffset = CircleMouseCursors[MouseCursorDB.Texture] and 0 or -13
            FUI.MouseCursor:SetScript("OnUpdate", function(mouseTexture) local mouseX, mouseY = GetCursorPosition() local uiScale = UIParent:GetEffectiveScale() mouseTexture:ClearAllPoints() mouseTexture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", mouseX / uiScale + xOffset, mouseY / uiScale + yOffset) end)
            FUI.MouseCursor:Show()
        else
            FUI.MouseCursor:Hide()
            FUI.MouseCursor:SetScript("OnUpdate", nil)
        end
    end
end

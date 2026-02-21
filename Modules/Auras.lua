local _, FUI = ...

local function CreatePixelBorder(aura)
    if aura.PixelBorder then return end

    local auraBorder = CreateFrame("Frame", nil, aura)
    auraBorder:SetAllPoints(aura.Icon)
    auraBorder:SetFrameLevel(aura:GetFrameLevel() - 1)
    aura.PixelBorder = auraBorder

    local function Edge(parent)
        return parent:CreateTexture(nil, "OVERLAY")
    end

    local borderTop = Edge(auraBorder)
    borderTop:SetColorTexture(0,0,0,1)
    borderTop:SetPoint("TOPLEFT", 0, 0)
    borderTop:SetPoint("TOPRIGHT", 0, 0)
    borderTop:SetHeight(1)

    local borderBottom = Edge(auraBorder)
    borderBottom:SetColorTexture(0,0,0,1)
    borderBottom:SetPoint("BOTTOMLEFT", 0, 0)
    borderBottom:SetPoint("BOTTOMRIGHT", 0, 0)
    borderBottom:SetHeight(1)

    local borderLeft = Edge(auraBorder)
    borderLeft:SetColorTexture(0,0,0,1)
    borderLeft:SetPoint("TOPLEFT", 0, 0)
    borderLeft:SetPoint("BOTTOMLEFT", 0, 0)
    borderLeft:SetWidth(1)

    local borderRight = Edge(auraBorder)
    borderRight:SetColorTexture(0,0,0,1)
    borderRight:SetPoint("TOPRIGHT", 0, 0)
    borderRight:SetPoint("BOTTOMRIGHT", 0, 0)
    borderRight:SetWidth(1)
end


local function StyleAuraFrame(aura)
    if aura.isAuraAnchor or not aura.Icon then return end
    local auraIcon, auraDuration, auraCount = aura.Icon, aura.Duration, aura.Count
    local auraBorder = aura.DebuffBorder or aura.BuffBorder
    auraIcon:SetSize(32, 32)
    auraIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    if auraBorder then auraBorder:SetTexture(nil) end
    if not aura.PixelBorder then CreatePixelBorder(aura) end

    local auraW, auraH = aura:GetSize()
    if auraW and auraH and auraW > 0 and auraH > 0 then
        aura.PixelBorder:ClearAllPoints()
        aura.PixelBorder:SetPoint("TOPLEFT", aura.Icon, "TOPLEFT", -1, 1)
        aura.PixelBorder:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", 1, -1)
    end

    if auraDuration then
        auraDuration:ClearAllPoints()
        auraDuration:SetPoint("CENTER", auraIcon, "BOTTOM", 0, 0)
        auraDuration:SetFont(FUI.Media.Font, 10, FUI.Media.FontFlag)
        auraDuration:SetShadowOffset(0, 0)
    end

    if auraCount then
        auraCount:ClearAllPoints()
        auraCount:SetPoint("BOTTOMRIGHT", auraIcon, "BOTTOMRIGHT", 2, 1)
        auraCount:SetFont(FUI.Media.Font, 10, FUI.Media.FontFlag)
    end
end

local function StyleExternalAuraFrame(aura)
    if aura.isAuraAnchor or not aura.Icon then return end
    local auraIcon, auraDuration, auraCount = aura.Icon, aura.Duration, aura.Count
    local auraBorder = aura.DebuffBorder or aura.BuffBorder
    auraIcon:SetSize(32, 32)
    auraIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    if auraBorder then auraBorder:SetTexture(nil) end
    if not aura.PixelBorder then CreatePixelBorder(aura) end

    local auraW, auraH = aura:GetSize()
    if auraW and auraH and auraW > 0 and auraH > 0 then
        aura.PixelBorder:ClearAllPoints()
        aura.PixelBorder:SetPoint("TOPLEFT", aura.Icon, "TOPLEFT", -1, 1)
        aura.PixelBorder:SetPoint("BOTTOMRIGHT", aura.Icon, "BOTTOMRIGHT", 1, -1)
    end

    if auraDuration then
        auraDuration:ClearAllPoints()
        auraDuration:SetPoint("CENTER", auraIcon, "BOTTOM", 0, 0)
        auraDuration:SetFont(FUI.Media.Font, 11, FUI.Media.FontFlag)
        auraDuration:SetShadowOffset(0, 0)
    end

    if auraCount then
        auraCount:ClearAllPoints()
        auraCount:SetPoint("BOTTOMRIGHT", auraIcon, "BOTTOMRIGHT", 0, 2)
        auraCount:SetFont(FUI.Media.Font, 11, FUI.Media.FontFlag)
    end
end

local function SpaceRows(self)
    if not self or not self.AuraContainer or not self.auraFrames then return end
    local iconStride = self.AuraContainer.iconStride or 12
    local iconPadding = self.AuraContainer.iconPadding or 5
    local previousAura, rowAnchor
    for i = 1, #self.auraFrames do
        local aura = self.auraFrames[i]
        if aura then
            aura:ClearAllPoints()
            local index = (i - 1) % iconStride
            if index == 0 then
                if not rowAnchor then
                    aura:SetPoint("TOPRIGHT", self, "TOPRIGHT", -iconPadding, 0)
                else
                    aura:SetPoint("TOPRIGHT", rowAnchor, "BOTTOMRIGHT", 0, 1)
                end
                rowAnchor = aura
            else
                aura:SetPoint("TOPRIGHT", previousAura, "TOPLEFT", -iconPadding, 0)
            end
            previousAura = aura
        end
    end
end

local function StyleBuffs()
    if not BuffFrame then return end
    BuffFrame.CollapseAndExpandButton:SetAlpha(0)
    BuffFrame.CollapseAndExpandButton:SetScript("OnClick", nil)
    for _, aura in pairs(BuffFrame.auraFrames) do
        if aura.TempEnchantBorder then
            aura.TempEnchantBorder:SetTexture(nil)
        end
        StyleAuraFrame(aura)
    end
end

local function StyleDebuffs()
    if not DebuffFrame then return end
    for _, aura in pairs(DebuffFrame.auraFrames) do
        StyleAuraFrame(aura)
        if aura.DebuffBorder then
            aura.DebuffBorder:Hide()
            aura.DebuffBorder:SetAlpha(0)
        end
    end
end

local function StyleExternalDefensives()
    if not ExternalDefensivesFrame then return end
    for _, aura in pairs(ExternalDefensivesFrame.auraFrames) do
        StyleExternalAuraFrame(aura)
    end
    ExternalDefensivesFrame:ClearAllPoints()
    ExternalDefensivesFrame:SetPoint("RIGHT", UUF_Player, "LEFT", -3, -10)
    ExternalDefensivesFrame:SetFrameStrata("MEDIUM")
end

function FUI:SetupAuraHooks()
    if not FUI.db.global.Skinning.SkinAuras then return end
    hooksecurefunc(EditModeManagerFrame, "EnterEditMode", function() FUI:SetupAuras() SpaceRows(BuffFrame) end)
    hooksecurefunc(EditModeManagerFrame, "ExitEditMode", function() FUI:SetupAuras() SpaceRows(BuffFrame) end)
    hooksecurefunc(DebuffFrame, "UpdateAuraButtons", function() StyleDebuffs() end)
end

function FUI:SetupAuras()
    if not FUI.db.global.Skinning.SkinAuras then return end
    StyleBuffs()
    StyleDebuffs()
    StyleExternalDefensives()
    SpaceRows(BuffFrame)
end
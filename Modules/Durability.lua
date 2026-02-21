local _, FUI = ...

local function FetchDurability()
    local totalDurability = 0
    local maxDurability = 0

    for i = 1, 18 do
        local current, maximum = GetInventoryItemDurability(i)
        if current and maximum then
            totalDurability = totalDurability + current
            maxDurability = maxDurability + maximum
        end
    end

    if maxDurability == 0 then return "N/A" end

    local durabilityPercent = (totalDurability / maxDurability) * 100
    return string.format("|cFF8080FFDurability|r: %.0f%%", durabilityPercent)
end

function FUI:SetupDurability()
    if not FUI.db.global.QualityOfLife.DurabilityFrame then return end
    local DurabilityFrame = CreateFrame("Frame", "FUI_DurabilityFrame", UIParent)
    DurabilityFrame:SetSize(128, 24)
    DurabilityFrame:SetPoint("TOP", CharacterModelScene, "TOP", 0, 2)
    DurabilityFrame:SetFrameStrata("HIGH")

    DurabilityFrame:SetScript("OnShow", function(self) self.Text:SetText(FetchDurability()) end)

    DurabilityFrame.Text = DurabilityFrame:CreateFontString(nil, "OVERLAY")
    DurabilityFrame.Text:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
    DurabilityFrame.Text:SetPoint("CENTER", DurabilityFrame, "CENTER")
    DurabilityFrame.Text:SetJustifyH("CENTER")
    DurabilityFrame.Text:SetText(FetchDurability())

    CharacterFrame:HookScript("OnShow", function() DurabilityFrame:Show() end)
    CharacterFrame:HookScript("OnHide", function() DurabilityFrame:Hide() end)
end
local _, FUI = ...

local function FetchItemLevel()
    local _, avgItemLevel = GetAverageItemLevel()
    return string.format("%.1f", avgItemLevel)
end

function FUI:SetupItemLevel()
    CharacterStatsPane.ItemLevelFrame.Value:SetAlpha(0)

    local ItemLevelFrame = CreateFrame("Frame", "FUI_ItemLevelFrame", CharacterStatsPane.ItemLevelFrame)
    ItemLevelFrame:SetSize(128, 24)
    ItemLevelFrame:SetPoint("CENTER", CharacterStatsPane.ItemLevelFrame, "CENTER", 0, 0)
    ItemLevelFrame:SetFrameStrata("HIGH")

    ItemLevelFrame:SetScript("OnShow", function(self) self.Text:SetText(FetchItemLevel()) end)

    ItemLevelFrame.Text = ItemLevelFrame:CreateFontString(nil, "OVERLAY")
    ItemLevelFrame.Text:SetFont(FUI.Media.Font, 16, FUI.Media.FontFlag)
    ItemLevelFrame.Text:SetPoint("CENTER", ItemLevelFrame, "CENTER")
    ItemLevelFrame.Text:SetText(FetchItemLevel())

    CharacterFrame:HookScript("OnShow", function() ItemLevelFrame:Show() end)
    CharacterFrame:HookScript("OnHide", function() ItemLevelFrame:Hide() end)
end
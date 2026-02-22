local _, FUI = ...
local FragUI = LibStub("AceAddon-3.0"):NewAddon("FragUI")

function FragUI:OnInitialize()
    FUI.db = LibStub("AceDB-3.0"):New("FUIDB", FUI:GetDefaultDB(), true)
end

function FragUI:OnEnable()
    FUI:SetupSlashCommands()
    FUI:ResolveLSM()
    FUI:SetupAuras()
    FUI:SetupAuraHooks()
    FUI:StyleBartender()
    FUI:SetupBugSack()
    FUI:SetupChat()
    FUI:StyleBlizzard()
    FUI:SetupCombatAlert()
    FUI:SetupCrosshair()
    FUI:SetupCVars()
    FUI:SetupDataTexts()
    FUI:SetupDetailsBackdrop()
    FUI:SetupDurability()
    FUI:SetupItemLevel()
    FUI:SetupMailIcon()
    FUI:SetupMicroMenu()
    FUI:SetupMouseCursor()
    FUI:SetupQualityOfLife()
end

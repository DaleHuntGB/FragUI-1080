local _, FUI = ...
local AG = LibStub("AceGUI-3.0")
local GUI = {}
local isGUIOpen = false
local LSM = FUI.LSM

local AnchorPoints = { { ["TOPLEFT"] = "Top Left", ["TOP"] = "Top", ["TOPRIGHT"] = "Top Right", ["LEFT"] = "Left", ["CENTER"] = "Center", ["RIGHT"] = "Right", ["BOTTOMLEFT"] = "Bottom Left", ["BOTTOM"] = "Bottom", ["BOTTOMRIGHT"] = "Bottom Right" }, { "TOPLEFT", "TOP", "TOPRIGHT", "LEFT", "CENTER", "RIGHT", "BOTTOMLEFT", "BOTTOM", "BOTTOMRIGHT", } }

local function CreateInformationTag(containerParent, labelDescription, justifyH)
    local informationLabel = AG:Create("Label")
    informationLabel:SetText(FUI.INFOBUTTON .. labelDescription)
    informationLabel:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    informationLabel:SetFullWidth(true)
    informationLabel:SetJustifyH(justifyH or "CENTER")
    informationLabel:SetHeight(24)
    informationLabel:SetJustifyV("MIDDLE")
    containerParent:AddChild(informationLabel)
    return informationLabel
end

local function HideElements()
    FUI.CombatAlertFrame:SetAlpha(0)
end

local function CreateLayoutOptions(parentContainer, dbValue, callBack)
    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(dbValue.Layout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[1] = value callBack() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    AnchorFromDropdown:SetDisabled(dbValue == FUI.db.global.Skinning.UIErrorsFrame and not FUI.db.global.Skinning.UIErrorsFrame.Enabled)
    parentContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(dbValue.Layout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[2] = value callBack() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    AnchorToDropdown:SetDisabled(dbValue == FUI.db.global.Skinning.UIErrorsFrame and not FUI.db.global.Skinning.UIErrorsFrame.Enabled)
    parentContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(dbValue.Layout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[3] = value callBack() end)
    XOffsetSlider:SetRelativeWidth(0.33)
    XOffsetSlider:SetDisabled(dbValue == FUI.db.global.Skinning.UIErrorsFrame and not FUI.db.global.Skinning.UIErrorsFrame.Enabled)
    parentContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(dbValue.Layout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[4] = value callBack() end)
    YOffsetSlider:SetRelativeWidth(0.33)
    YOffsetSlider:SetDisabled(dbValue == FUI.db.global.Skinning.UIErrorsFrame and not FUI.db.global.Skinning.UIErrorsFrame.Enabled)
    parentContainer:AddChild(YOffsetSlider)

    local FontSizeSlider = AG:Create("Slider")
    FontSizeSlider:SetLabel("Font Size")
    FontSizeSlider:SetValue(dbValue.FontSize)
    FontSizeSlider:SetSliderValues(6, 32, 1)
    FontSizeSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.FontSize = value callBack() end)
    FontSizeSlider:SetRelativeWidth(0.33)
    FontSizeSlider:SetDisabled(dbValue == FUI.db.global.Skinning.UIErrorsFrame and not FUI.db.global.Skinning.UIErrorsFrame.Enabled)
    parentContainer:AddChild(FontSizeSlider)

    return parentContainer
end

local function CreateSkinningSettings(parentContainer)
    local SkinningDB = FUI.db.global.Skinning

    local FontSelectionContainer = AG:Create("InlineGroup")
    FontSelectionContainer:SetTitle("Font Selection")
    FontSelectionContainer:SetLayout("Flow")
    FontSelectionContainer:SetFullWidth(true)
    parentContainer:AddChild(FontSelectionContainer)

    local FontDropdown = AG:Create("LSM30_Font")
    FontDropdown:SetList(LSM:HashTable("font"))
    FontDropdown:SetLabel("Font")
    FontDropdown:SetValue(FUI.db.global.Fonts.Font)
    FontDropdown:SetRelativeWidth(0.5)
    FontDropdown:SetCallback("OnValueChanged", function(widget, _, value) widget:SetValue(value) FUI.db.global.Fonts.Font = value FUI:PromptReload() end)
    FontSelectionContainer:AddChild(FontDropdown)

    -- local DamageFontDropdown = AG:Create("LSM30_Font")
    -- DamageFontDropdown:SetList(LSM:HashTable("font"))
    -- DamageFontDropdown:SetLabel("Damage Font")
    -- DamageFontDropdown:SetValue(FUI.db.global.Fonts.DamageFont)
    -- DamageFontDropdown:SetRelativeWidth(0.33)
    -- DamageFontDropdown:SetCallback("OnValueChanged", function(widget, _, value) widget:SetValue(value) FUI.db.global.Fonts.DamageFont = value FUI:PromptReload() end)
    -- FontSelectionContainer:AddChild(DamageFontDropdown)

    local FontFlagDropdown = AG:Create("Dropdown")
    FontFlagDropdown:SetList({ ["None"] = "None", ["OUTLINE"] = "Outline", ["THICKOUTLINE"] = "Thick Outline", ["MONOCHROME"] = "Monochrome", ["MONOCHROME, OUTLINE"] = "Monochrome Outline", ["MONOCHROME, THICKOUTLINE"] = "Monochrome Thick Outline" }, { "None", "OUTLINE", "THICKOUTLINE", "MONOCHROME", "MONOCHROME, OUTLINE", "MONOCHROME, THICKOUTLINE" })
    FontFlagDropdown:SetLabel("Font Flags")
    FontFlagDropdown:SetValue(FUI.db.global.Fonts.FontFlag)
    FontFlagDropdown:SetRelativeWidth(0.5)
    FontFlagDropdown:SetCallback("OnValueChanged", function(widget, _, value) widget:SetValue(value) FUI.db.global.Fonts.FontFlag = value FUI:PromptReload() end)
    FontSelectionContainer:AddChild(FontFlagDropdown)

    local SkinningContainer = AG:Create("InlineGroup")
    SkinningContainer:SetTitle("Skinning")
    SkinningContainer:SetLayout("Flow")
    SkinningContainer:SetFullWidth(true)
    parentContainer:AddChild(SkinningContainer)

    local SortOrder = { "SkinActionBars", "SkinAuras", "SkinMicroMenu", "HideBlizzardTextures"}

    local OptionsForSkinning = {
        ["SkinAuras"] = {Title = "Skin Auras", Desc = "Skins Buffs, Debuffs and External Defensive Auras."},
        ["SkinActionBars"] = {Title = "Skin Action Bars", Desc = "Skins Action Bars."},
        ["SkinMicroMenu"] = {Title = "Skin Micro Menu", Desc = "Skins the Micro Menu."},
        ["HideBlizzardTextures"] = {Title = "Skin Blizzard Frames", Desc = "Hides Blizzard Textures/Frames such as |cFFFFCC00Zone Text|r and |cFFFFCC00Objective Tracker|r."},
    }

    for _, optionKey in ipairs(SortOrder) do
        local optionDescription = OptionsForSkinning[optionKey]
        local optionToggle = AG:Create("CheckBox")
        optionToggle:SetLabel(optionDescription.Title)
        optionToggle:SetDescription("|cFFCCCCCC" .. optionDescription.Desc .. "|r")
        optionToggle:SetValue(SkinningDB[optionKey])
        optionToggle:SetCallback("OnValueChanged", function(_, _, value) SkinningDB[optionKey] = value FUI:PromptReload() end)
        optionToggle:SetRelativeWidth(1)
        SkinningContainer:AddChild(optionToggle)
    end

    if C_AddOns.IsAddOnLoaded("Baganator") then
        CreateInformationTag(SkinningContainer, "A skin for |TInterface\\AddOns\\Baganator\\Assets\\logo.tga:16:16|t |cFF8080FFBaganator|r is provided. If you want to use it, please set the theme to |cFFFFCC00Dark|r and reload.", "LEFT")
    end

    if C_AddOns.IsAddOnLoaded("ls_Toasts") then
        CreateInformationTag(SkinningContainer, "A skin for |TInterface\\AddOns\\ls_Toasts\\assets\\logo-64.tga:16:16|t |cFF8080FFLS: Toasts|r is provided. If you want to use it, please set the theme to |cFFFFCC00FragUI|r.", "LEFT")
    end

    local BlizzardFontsContainer = AG:Create("InlineGroup")
    BlizzardFontsContainer:SetTitle("Blizzard Fonts")
    BlizzardFontsContainer:SetLayout("Flow")
    BlizzardFontsContainer:SetFullWidth(true)
    parentContainer:AddChild(BlizzardFontsContainer)

    local UIErrorsFrameContainer = AG:Create("InlineGroup")
    UIErrorsFrameContainer:SetTitle("UI Errors")
    UIErrorsFrameContainer:SetLayout("Flow")
    UIErrorsFrameContainer:SetFullWidth(true)
    BlizzardFontsContainer:AddChild(UIErrorsFrameContainer)

    local EnableToggle = AG:Create("CheckBox")
    EnableToggle:SetLabel("Enable")
    EnableToggle:SetDescription("|cFFCCCCCCThis will disable the |cFFFFCC00UI Errors Frame|r, which displays error messages such as |cFFFFCC00Out of Range|r and |cFFFFCC00Not Enough Mana|r|r.")
    EnableToggle:SetValue(SkinningDB.UIErrorsFrame.Enabled)
    EnableToggle:SetCallback("OnValueChanged", function(_, _, value) SkinningDB.UIErrorsFrame.Enabled = value FUI:PromptReload() end)
    EnableToggle:SetRelativeWidth(1)
    UIErrorsFrameContainer:AddChild(EnableToggle)

    CreateLayoutOptions(UIErrorsFrameContainer, SkinningDB.UIErrorsFrame, function() FUI:UpdateUIErrorsFrame() end)

    local ActionStatusContainer = AG:Create("InlineGroup")
    ActionStatusContainer:SetTitle("Action Status")
    ActionStatusContainer:SetLayout("Flow")
    ActionStatusContainer:SetFullWidth(true)
    BlizzardFontsContainer:AddChild(ActionStatusContainer)

    CreateLayoutOptions(ActionStatusContainer, SkinningDB.ActionStatus, function() FUI:UpdateActionStatus() end)

    local ObjectiveTrackerContainer = AG:Create("InlineGroup")
    ObjectiveTrackerContainer:SetTitle("Objective Tracker")
    ObjectiveTrackerContainer:SetLayout("Flow")
    ObjectiveTrackerContainer:SetFullWidth(true)
    BlizzardFontsContainer:AddChild(ObjectiveTrackerContainer)

    local ObjectiveTrackerHeaderFontSizeSlider = AG:Create("Slider")
    ObjectiveTrackerHeaderFontSizeSlider:SetLabel("Quest Header Font Size")
    ObjectiveTrackerHeaderFontSizeSlider:SetValue(SkinningDB.ObjectiveTracker.Header.FontSize)
    ObjectiveTrackerHeaderFontSizeSlider:SetSliderValues(6, 32, 1)
    ObjectiveTrackerHeaderFontSizeSlider:SetCallback("OnValueChanged", function(_, _, value) SkinningDB.ObjectiveTracker.Header.FontSize = value FUI:UpdateObjectiveTrackerFont() end)
    ObjectiveTrackerHeaderFontSizeSlider:SetRelativeWidth(0.5)
    ObjectiveTrackerContainer:AddChild(ObjectiveTrackerHeaderFontSizeSlider)

    local ObjectiveTrackerLineFontSizeSlider = AG:Create("Slider")
    ObjectiveTrackerLineFontSizeSlider:SetLabel("Objective Font Size")
    ObjectiveTrackerLineFontSizeSlider:SetValue(SkinningDB.ObjectiveTracker.Text.FontSize)
    ObjectiveTrackerLineFontSizeSlider:SetSliderValues(6, 32, 1)
    ObjectiveTrackerLineFontSizeSlider:SetCallback("OnValueChanged", function(_, _, value) SkinningDB.ObjectiveTracker.Text.FontSize = value FUI:UpdateObjectiveTrackerFont() end)
    ObjectiveTrackerLineFontSizeSlider:SetRelativeWidth(0.5)
    ObjectiveTrackerContainer:AddChild(ObjectiveTrackerLineFontSizeSlider)

    local ChatBubbleContainer = AG:Create("InlineGroup")
    ChatBubbleContainer:SetTitle("Chat Bubbles")
    ChatBubbleContainer:SetLayout("Flow")
    ChatBubbleContainer:SetFullWidth(true)
    BlizzardFontsContainer:AddChild(ChatBubbleContainer)

    local ChatBubbleFontSizeSlider = AG:Create("Slider")
    ChatBubbleFontSizeSlider:SetLabel("Chat Bubble Font Size")
    ChatBubbleFontSizeSlider:SetValue(SkinningDB.ChatBubbleFont.FontSize)
    ChatBubbleFontSizeSlider:SetSliderValues(6, 32, 1)
    ChatBubbleFontSizeSlider:SetCallback("OnValueChanged", function(_, _, value) SkinningDB.ChatBubbleFont.FontSize = value FUI:UpdateChatBubbleFont() end)
    ChatBubbleFontSizeSlider:SetRelativeWidth(1)
    ChatBubbleContainer:AddChild(ChatBubbleFontSizeSlider)

    return parentContainer
end

local function CreateChatLayoutOptions(parentContainer, dbValue, callBack)
    local EnableToggle = AG:Create("CheckBox")
    EnableToggle:SetLabel("Enable")
    EnableToggle:SetDescription("|cFFCCCCCC" .. "Toggle Chat Backdrop." .. "|r")
    EnableToggle:SetValue(dbValue.EnableBackdrop)
    EnableToggle:SetCallback("OnValueChanged", function(_, _, value) dbValue.EnableBackdrop = value callBack() UpdateChatBackdropSettings() end)
    EnableToggle:SetRelativeWidth(0.5)
    parentContainer:AddChild(EnableToggle)

    local ColourPicker = AG:Create("ColorPicker")
    ColourPicker:SetLabel("Backdrop Colour")
    ColourPicker:SetColor(unpack(dbValue.Colour))
    ColourPicker:SetHasAlpha(true)
    ColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) dbValue.Colour = { r, g, b, a } callBack() end)
    ColourPicker:SetRelativeWidth(0.5)
    parentContainer:AddChild(ColourPicker)

    local WidthSlider = AG:Create("Slider")
    WidthSlider:SetLabel("Width")
    WidthSlider:SetValue(dbValue.Width)
    WidthSlider:SetSliderValues(100, 2000, 1)
    WidthSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Width = value callBack() end)
    WidthSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(WidthSlider)

    local HeightSlider = AG:Create("Slider")
    HeightSlider:SetLabel("Height")
    HeightSlider:SetValue(dbValue.Height)
    HeightSlider:SetSliderValues(100, 2000, 1)
    HeightSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Height = value callBack() end)
    HeightSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(HeightSlider)

    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(dbValue.Layout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[1] = value  callBack() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    parentContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(dbValue.Layout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[2] = value callBack() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    parentContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(dbValue.Layout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[3] = value callBack() end)
    XOffsetSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(dbValue.Layout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Layout[4] = value callBack() end)
    YOffsetSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(YOffsetSlider)

    function UpdateChatBackdropSettings()
        ColourPicker:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        WidthSlider:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        HeightSlider:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        AnchorFromDropdown:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        AnchorToDropdown:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        XOffsetSlider:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
        YOffsetSlider:SetDisabled(not FUI.db.global.Chat.EnableBackdrop)
    end

    UpdateChatBackdropSettings()

    return parentContainer
end

local function CreateChatSettings(parentContainer)
    local ChatDB = FUI.db.global.Chat

    local SkinChatToggle = AG:Create("CheckBox")
    SkinChatToggle:SetLabel("Skin Chat")
    SkinChatToggle:SetDescription("|cFFCCCCCC" .. "Skins the Chat Edit Box." .. "|r")
    SkinChatToggle:SetValue(ChatDB.SkinChat)
    SkinChatToggle:SetCallback("OnValueChanged", function(_, _, value) ChatDB.SkinChat = value FUI:PromptReload() end)
    SkinChatToggle:SetRelativeWidth(1)
    parentContainer:AddChild(SkinChatToggle)

    local LayoutContainer = AG:Create("InlineGroup")
    LayoutContainer:SetTitle("Chat Backdrop")
    LayoutContainer:SetLayout("Flow")
    LayoutContainer:SetFullWidth(true)
    parentContainer:AddChild(LayoutContainer)

    CreateChatLayoutOptions(LayoutContainer, ChatDB, function() FUI:UpdateChatBackdrop() end)

    return parentContainer
end

local function CreateCombatAlertSettings(parentContainer)
    local CombatAlertDB = FUI.db.global.CombatAlert
    GUI.CombatAlert = GUI.CombatAlert or {}

    local EnableToggle = AG:Create("CheckBox")
    EnableToggle:SetLabel("Enable")
    EnableToggle:SetValue(CombatAlertDB.Enabled)
    EnableToggle:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.Enabled = value FUI:UpdateCombatAlert() GUI.CombatAlert:UpdateCombatAlertSettings() end)
    EnableToggle:SetRelativeWidth(1)
    parentContainer:AddChild(EnableToggle)

    local TextContainer = AG:Create("InlineGroup")
    TextContainer:SetTitle("Texts")
    TextContainer:SetLayout("Flow")
    TextContainer:SetFullWidth(true)
    parentContainer:AddChild(TextContainer)

    local EnteringCombatTextEditBox = AG:Create("EditBox")
    EnteringCombatTextEditBox:SetLabel("Entering Combat Text")
    EnteringCombatTextEditBox:SetText(CombatAlertDB.Text[1])
    EnteringCombatTextEditBox:SetCallback("OnTextChanged", function(_, _, value) FUI.db.global.CombatAlert.Text[1] = value FUI:UpdateCombatAlert() end)
    EnteringCombatTextEditBox:SetRelativeWidth(0.5)
    TextContainer:AddChild(EnteringCombatTextEditBox)

    local LeavingCombatTextEditBox = AG:Create("EditBox")
    LeavingCombatTextEditBox:SetLabel("Leaving Combat Text")
    LeavingCombatTextEditBox:SetText(CombatAlertDB.Text[2])
    LeavingCombatTextEditBox:SetCallback("OnTextChanged", function(_, _, value) FUI.db.global.CombatAlert.Text[2] = value FUI:UpdateCombatAlert() end)
    LeavingCombatTextEditBox:SetRelativeWidth(0.5)
    TextContainer:AddChild(LeavingCombatTextEditBox)

    local LayoutContainer = AG:Create("InlineGroup")
    LayoutContainer:SetTitle("Layout")
    LayoutContainer:SetLayout("Flow")
    LayoutContainer:SetFullWidth(true)
    parentContainer:AddChild(LayoutContainer)

    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(CombatAlertDB.Layout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.Layout[1] = value FUI:UpdateCombatAlert() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(CombatAlertDB.Layout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.Layout[2] = value FUI:UpdateCombatAlert() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(CombatAlertDB.Layout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.Layout[3] = value FUI:UpdateCombatAlert() end)
    XOffsetSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(CombatAlertDB.Layout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.Layout[4] = value FUI:UpdateCombatAlert() end)
    YOffsetSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(YOffsetSlider)

    local FontSizeSlider = AG:Create("Slider")
    FontSizeSlider:SetLabel("Font Size")
    FontSizeSlider:SetValue(CombatAlertDB.FontSize)
    FontSizeSlider:SetSliderValues(6, 32, 1)
    FontSizeSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CombatAlert.FontSize = value FUI:UpdateCombatAlert() end)
    FontSizeSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(FontSizeSlider)

    local ColourContainer = AG:Create("InlineGroup")
    ColourContainer:SetTitle("Colours")
    ColourContainer:SetLayout("Flow")
    ColourContainer:SetFullWidth(true)
    parentContainer:AddChild(ColourContainer)

    local InCombatColourPicker = AG:Create("ColorPicker")
    InCombatColourPicker:SetLabel("In Combat Colour")
    InCombatColourPicker:SetColor(unpack(CombatAlertDB.InCombatColour))
    InCombatColourPicker:SetHasAlpha(true)
    InCombatColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) FUI.db.global.CombatAlert.InCombatColour = { r, g, b, a } FUI:UpdateCombatAlert() end)
    InCombatColourPicker:SetRelativeWidth(0.5)
    ColourContainer:AddChild(InCombatColourPicker)

    local OutOfCombatColourPicker = AG:Create("ColorPicker")
    OutOfCombatColourPicker:SetLabel("Out of Combat Colour")
    OutOfCombatColourPicker:SetColor(unpack(CombatAlertDB.OutOfCombatColour))
    OutOfCombatColourPicker:SetHasAlpha(true)
    OutOfCombatColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) FUI.db.global.CombatAlert.OutOfCombatColour = { r, g, b, a } FUI:UpdateCombatAlert() end)
    OutOfCombatColourPicker:SetRelativeWidth(0.5)
    ColourContainer:AddChild(OutOfCombatColourPicker)

    function GUI.CombatAlert:UpdateCombatAlertSettings()
        EnteringCombatTextEditBox:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        LeavingCombatTextEditBox:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        AnchorFromDropdown:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        AnchorToDropdown:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        XOffsetSlider:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        YOffsetSlider:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        FontSizeSlider:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        InCombatColourPicker:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
        OutOfCombatColourPicker:SetDisabled(not FUI.db.global.CombatAlert.Enabled)
    end

    GUI.CombatAlert:UpdateCombatAlertSettings()

    return parentContainer
end

local function CreateCrosshairSettings(parentContainer)
    local CrosshairDB = FUI.db.global.Crosshair
    GUI.Crosshair = GUI.Crosshair or {}

    local EnableToggle = AG:Create("CheckBox")
    EnableToggle:SetLabel("Enable")
    EnableToggle:SetValue(CrosshairDB.Enabled)
    EnableToggle:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Enabled = value FUI:UpdateCrosshair() GUI.Crosshair:UpdateCrosshairSettings() end)
    EnableToggle:SetRelativeWidth(0.33)
    parentContainer:AddChild(EnableToggle)

    local OnlyShowInCombatToggle = AG:Create("CheckBox")
    OnlyShowInCombatToggle:SetLabel("Show In Combat Only")
    OnlyShowInCombatToggle:SetValue(CrosshairDB.ShowInCombatOnly)
    OnlyShowInCombatToggle:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.ShowInCombatOnly = value FUI:UpdateCrosshair() GUI.Crosshair:UpdateCrosshairSettings() end)
    OnlyShowInCombatToggle:SetRelativeWidth(0.33)
    parentContainer:AddChild(OnlyShowInCombatToggle)

    local CrosshairTextureDropdown = AG:Create("Dropdown")
    CrosshairTextureDropdown:SetLabel("Crosshair Texture")
    CrosshairTextureDropdown:SetList({ ["Plus"] = "|T" .. FUI.CROSSHAIR_TEXTURES["Plus"] .. ":16:16|t", ["Dot"] = "|T" .. FUI.CROSSHAIR_TEXTURES["Dot"] .. ":16:16|t", ["CircleCircle"] = "|T" .. FUI.CROSSHAIR_TEXTURES["CircleCircle"] .. ":16:16|t", ["Circle"] = "|T" .. FUI.CROSSHAIR_TEXTURES["Circle"] .. ":16:16|t", ["Diamond"] = "|T" .. FUI.CROSSHAIR_TEXTURES["Diamond"] .. ":16:16|t" }, { "Plus", "Dot", "CircleCircle", "Circle", "Diamond" })
    CrosshairTextureDropdown:SetValue(CrosshairDB.Texture)
    CrosshairTextureDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Texture = value FUI:UpdateCrosshair() end)
    CrosshairTextureDropdown:SetRelativeWidth(0.33)
    parentContainer:AddChild(CrosshairTextureDropdown)

    local LayoutContainer = AG:Create("InlineGroup")
    LayoutContainer:SetTitle("Layout")
    LayoutContainer:SetLayout("Flow")
    LayoutContainer:SetFullWidth(true)
    parentContainer:AddChild(LayoutContainer)

    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(CrosshairDB.Layout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Layout[1] = value FUI:UpdateCrosshair() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(CrosshairDB.Layout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Layout[2] = value FUI:UpdateCrosshair() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(CrosshairDB.Layout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Layout[3] = value FUI:UpdateCrosshair() end)
    XOffsetSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(CrosshairDB.Layout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Layout[4] = value FUI:UpdateCrosshair() end)
    YOffsetSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(YOffsetSlider)

    local SizeSlider = AG:Create("Slider")
    SizeSlider:SetLabel("Size")
    SizeSlider:SetValue(CrosshairDB.Size)
    SizeSlider:SetSliderValues(12, 32, 1)
    SizeSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Crosshair.Size = value FUI:UpdateCrosshair() end)
    SizeSlider:SetRelativeWidth(0.33)
    LayoutContainer:AddChild(SizeSlider)

    local ColourContainer = AG:Create("InlineGroup")
    ColourContainer:SetTitle("Colours")
    ColourContainer:SetLayout("Flow")
    ColourContainer:SetFullWidth(true)
    parentContainer:AddChild(ColourContainer)

    local ColourPicker = AG:Create("ColorPicker")
    ColourPicker:SetLabel("Colour")
    ColourPicker:SetColor(unpack(CrosshairDB.Colour))
    ColourPicker:SetHasAlpha(true)
    ColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) FUI.db.global.Crosshair.Colour = { r, g, b, a } FUI:UpdateCrosshair() end)
    ColourPicker:SetRelativeWidth(0.5)
    ColourContainer:AddChild(ColourPicker)

    function GUI.Crosshair:UpdateCrosshairSettings()
        OnlyShowInCombatToggle:SetDisabled(not FUI.db.global.Crosshair.Enabled)
        AnchorFromDropdown:SetDisabled(not FUI.db.global.Crosshair.Enabled)
        AnchorToDropdown:SetDisabled(not FUI.db.global.Crosshair.Enabled)
        XOffsetSlider:SetDisabled(not FUI.db.global.Crosshair.Enabled)
        YOffsetSlider:SetDisabled(not FUI.db.global.Crosshair.Enabled)
        ColourPicker:SetDisabled(not FUI.db.global.Crosshair.Enabled)
    end

    GUI.Crosshair:UpdateCrosshairSettings()

    return parentContainer
end

local function CreateCVarsSettings(parentContainer)
    local GraphicsSettingsContainer = AG:Create("InlineGroup")
    GraphicsSettingsContainer:SetTitle("Performance Enhancements")
    GraphicsSettingsContainer:SetLayout("Flow")
    GraphicsSettingsContainer:SetFullWidth(true)
    parentContainer:AddChild(GraphicsSettingsContainer)

    local BackupCurrentGraphicsSettingsButton = AG:Create("Button")
    BackupCurrentGraphicsSettingsButton:SetText("Backup Settings")
    BackupCurrentGraphicsSettingsButton:SetCallback("OnClick", function() FUI:BackupGraphicsSettings() ToggleButtons() end)
    BackupCurrentGraphicsSettingsButton:SetRelativeWidth(0.5)
    BackupCurrentGraphicsSettingsButton:SetHeight(32)
    BackupCurrentGraphicsSettingsButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    BackupCurrentGraphicsSettingsButton.frame.Text:SetShadowColor(0,0,0,0)
    BackupCurrentGraphicsSettingsButton:SetDisabled(FUI.db.global.GraphicSettingsBackup.hasBeenBackedUp)
    GraphicsSettingsContainer:AddChild(BackupCurrentGraphicsSettingsButton)

    local RestoreGraphicsSettingsButton = AG:Create("Button")
    RestoreGraphicsSettingsButton:SetText("Restore Settings")
    RestoreGraphicsSettingsButton:SetCallback("OnClick", function() FUI:RestoreGraphics() end)
    RestoreGraphicsSettingsButton:SetRelativeWidth(0.5)
    RestoreGraphicsSettingsButton:SetHeight(32)
    RestoreGraphicsSettingsButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    RestoreGraphicsSettingsButton.frame.Text:SetShadowColor(0,0,0,0)
    RestoreGraphicsSettingsButton:SetDisabled(not FUI.db.global.GraphicSettingsBackup.hasBeenBackedUp)
    GraphicsSettingsContainer:AddChild(RestoreGraphicsSettingsButton)

    local ApplyFragnanceGraphicsSettingsButton = AG:Create("Button")
    ApplyFragnanceGraphicsSettingsButton:SetText("|cFF8080FFFragnance|r Graphics")
    ApplyFragnanceGraphicsSettingsButton:SetCallback("OnClick", function() FUI:SetupGraphics() end)
    ApplyFragnanceGraphicsSettingsButton:SetCallback("OnEnter", function() GameTooltip:SetOwner(ApplyFragnanceGraphicsSettingsButton.frame, "ANCHOR_CURSOR") GameTooltip:AddLine(FUI:FetchGraphicsOptionsForTooltip(), nil, nil, nil, true) GameTooltip:Show() end)
    ApplyFragnanceGraphicsSettingsButton:SetCallback("OnLeave", function() GameTooltip:Hide() end)
    ApplyFragnanceGraphicsSettingsButton:SetRelativeWidth(1)
    ApplyFragnanceGraphicsSettingsButton:SetHeight(32)
    ApplyFragnanceGraphicsSettingsButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    ApplyFragnanceGraphicsSettingsButton.frame.Text:SetShadowColor(0,0,0,0)
    ApplyFragnanceGraphicsSettingsButton:SetDisabled(not FUI.db.global.GraphicSettingsBackup.hasBeenBackedUp)
    GraphicsSettingsContainer:AddChild(ApplyFragnanceGraphicsSettingsButton)

    local ToggleContainer = AG:Create("InlineGroup")
    ToggleContainer:SetTitle("Toggles")
    ToggleContainer:SetLayout("Flow")
    ToggleContainer:SetFullWidth(true)
    parentContainer:AddChild(ToggleContainer)

    local ApplyCVarsGloballyToggle = AG:Create("CheckBox")
    ApplyCVarsGloballyToggle:SetLabel("Apply CVars Globally")
    ApplyCVarsGloballyToggle:SetDescription("|cFFCCCCCCApply Below CVars Automatically.|r")
    ApplyCVarsGloballyToggle:SetValue(FUI.db.global.CVars.ApplyGlobally)
    ApplyCVarsGloballyToggle:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CVars.ApplyGlobally = value FUI:SetupCVars() end)
    ApplyCVarsGloballyToggle:SetRelativeWidth(1)
    ToggleContainer:AddChild(ApplyCVarsGloballyToggle)

    local function GetStoredCVarValue(cvarName)
        local values = FUI.db.global.CVars.Values
        if values[cvarName] == nil then
            values[cvarName] = C_CVar.GetCVar(cvarName) or "0"
        end
        return values[cvarName]
    end

    local ToggleCVars = {
        { Label = "Floating Combat Text: |cFF8080FFPlayer|r", CVar = "floatingCombatTextCombatDamage_v2", Desc = "Displays Floating Combat Text for Player |cFFFF4040Damage|r / |cFF40FF40Healing|r." },
        { Label = "Floating Combat Text: |cFFFF4040Damage|r", CVar = "floatingCombatTextCombatDamage_v2", Desc = "Displays Floating Combat Damage." },
        { Label = "Floating Combat Text: |cFF40FF40Healing|r", CVar = "floatingCombatTextCombatHealing_v2", Desc = "Displays Floating Combat Healing." },
        { Label = "Floating Combat Text: |cFFFFCC00Reactives|r", CVar = "floatingCombatTextReactives_v2", Desc = "Displays Reactive Ability Notifications." },
        { Label = "Find Yourself Anywhere: |cFF8080FFOutline|r", CVar = "findYourselfModeOutline", Desc = "Adds Outline to Your Player Character." },
        { Label = "Obstruction Silhouette", CVar = "occludedSilhouettePlayer", Desc = "Display a Silhouette of your Character when Obstructed." },
        { Label = "Death Effects", CVar = "ffxDeath", Desc = "Displays Death Overlay / Desaturation." },
        { Label = "Fullscreen Glow", CVar = "ffxGlow", Desc = "Displays Fullscreen Glow Effect.\n|cFFFFCC00Can be a small FPS improvement|r." },
        { Label = "Sharpen Textures", CVar = "ResampleAlwaysSharpen", Desc = "Sharpens Up Textures." },
        { Label = "Auto Loot", CVar = "autoLootDefault", Desc = "Automatically Loot." },
        { Label = "External Defensives", CVar = "externalDefensivesEnabled", Desc = "External Defensives Auras." },
        { Label = "|cFF8080FFNameplates|r: Show Only Friendly Player Names", CVar = "nameplateShowOnlyNameForFriendlyPlayerUnits", Desc = "Only Shows Names on Friendly Player Nameplates.\n|cFFFFCC00Friendly Nameplates must be on for this to work|r." },
        { Label = "|cFF8080FFNameplates|r: Use Class Colors for Friendly Player Names", CVar = "nameplateUseClassColorForFriendlyPlayerUnitNames", Desc = "Uses Class Colors for Friendly Player Nameplates.\n|cFFFFCC00Friendly Nameplates must be on for this to work|r." },
    }

    for _, toggleInfo in ipairs(ToggleCVars) do
        local cVarToggle = AG:Create("CheckBox")
        cVarToggle:SetLabel(toggleInfo.Label)
        cVarToggle:SetDescription("|cFFCCCCCC" .. toggleInfo.Desc .. "|r")
        cVarToggle:SetValue(GetStoredCVarValue(toggleInfo.CVar) == "1")
        cVarToggle:SetCallback("OnValueChanged", function(_, _, value) local newValue = value and "1" or "0" FUI.db.global.CVars.Values[toggleInfo.CVar] = newValue C_CVar.SetCVar(toggleInfo.CVar, newValue) end)
        cVarToggle:SetFullWidth(true)
        ToggleContainer:AddChild(cVarToggle)
    end

    local SliderContainer = AG:Create("InlineGroup")
    SliderContainer:SetTitle("Sliders")
    SliderContainer:SetLayout("Flow")
    SliderContainer:SetFullWidth(true)
    parentContainer:AddChild(SliderContainer)

    local SliderCVars = {
        { Label = "Spell Queue Window", CVar = "SpellQueueWindow" },
        { Label = "Raid: Water Detail", CVar = "RAIDWaterDetail"},
        { Label = "Raid: Weather Density", CVar = "RAIDweatherDensity"},
        { Label = "Auto Loot: Rate", CVar = "autoLootRate"},
    }

    for _, sliderInfo in ipairs(SliderCVars) do
        local cVarSlider = AG:Create("Slider")
        cVarSlider:SetLabel(sliderInfo.Label)
        cVarSlider:SetValue(tonumber(GetStoredCVarValue(sliderInfo.CVar)) or 0)
        cVarSlider:SetSliderValues(0, (sliderInfo.CVar == "SpellQueueWindow" and 400) or (sliderInfo.CVar == "autoLootRate" and 150) or 3, 1)
        cVarSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.CVars.Values[sliderInfo.CVar] = tostring(value) C_CVar.SetCVar(sliderInfo.CVar, tostring(value)) end)
        cVarSlider:SetRelativeWidth(0.5)
        SliderContainer:AddChild(cVarSlider)
    end

    function ToggleButtons()
        local hasBackup = FUI.db.global.GraphicSettingsBackup.hasBeenBackedUp
        BackupCurrentGraphicsSettingsButton:SetDisabled(hasBackup)
        RestoreGraphicsSettingsButton:SetDisabled(not hasBackup)
        ApplyFragnanceGraphicsSettingsButton:SetDisabled(not hasBackup)
    end

    return parentContainer
end

local function CreateDetailsLayoutOptions(parentContainer, dbValue, callBack)
    local EnabledCheckBox = AG:Create("CheckBox")
    EnabledCheckBox:SetLabel("Enable Backdrop")
    EnabledCheckBox:SetValue(dbValue.Enabled)
    EnabledCheckBox:SetCallback("OnValueChanged", function(_, _, value) dbValue.Enabled = value callBack() end)
    EnabledCheckBox:SetRelativeWidth(0.5)
    parentContainer:AddChild(EnabledCheckBox)

    local ColourPicker = AG:Create("ColorPicker")
    ColourPicker:SetLabel("Backdrop Colour")
    ColourPicker:SetColor(unpack(dbValue.Colour))
    ColourPicker:SetHasAlpha(true)
    ColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) dbValue.Colour = { r, g, b, a } callBack() end)
    ColourPicker:SetRelativeWidth(0.5)
    parentContainer:AddChild(ColourPicker)

    local WidthSlider = AG:Create("Slider")
    WidthSlider:SetLabel("Width")
    WidthSlider:SetValue(dbValue.Width)
    WidthSlider:SetSliderValues(100, 2000, 1)
    WidthSlider:SetCallback("OnValueChanged", function(_, _, value) dbValue.Width = value callBack() end)
    WidthSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(WidthSlider)

    local isHorizontalLayout = (FUI.db.global.Details.Layout == "HORIZONTAL")

    local RowsSlider = AG:Create("Slider")
    RowsSlider:SetLabel("Number of Rows")
    RowsSlider:SetValue(isHorizontalLayout and dbValue.HorizontalRows or dbValue.VerticalRows)
    RowsSlider:SetSliderValues(1, 20, 1)
    RowsSlider:SetCallback("OnValueChanged", function(_, _, value) if isHorizontalLayout then dbValue.HorizontalRows = value else dbValue.VerticalRows = value end callBack() end)
    RowsSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(RowsSlider)


    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(isHorizontalLayout and dbValue.HorizontalLayout[1] or dbValue.VerticalLayout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) if isHorizontalLayout then dbValue.HorizontalLayout[1] = value else dbValue.VerticalLayout[1] = value end callBack() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    parentContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(isHorizontalLayout and dbValue.HorizontalLayout[2] or dbValue.VerticalLayout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) if isHorizontalLayout then dbValue.HorizontalLayout[2] = value else dbValue.VerticalLayout[2] = value end callBack() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    parentContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(isHorizontalLayout and dbValue.HorizontalLayout[3] or dbValue.VerticalLayout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) if isHorizontalLayout then dbValue.HorizontalLayout[3] = value else dbValue.VerticalLayout[3] = value end callBack() end)
    XOffsetSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(isHorizontalLayout and dbValue.HorizontalLayout[4] or dbValue.VerticalLayout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) if isHorizontalLayout then dbValue.HorizontalLayout[4] = value else dbValue.VerticalLayout[4] = value end callBack() end)
    YOffsetSlider:SetRelativeWidth(0.5)
    parentContainer:AddChild(YOffsetSlider)

    return parentContainer
end

local function CreateDetailsSettings(parentContainer)
    local DetailsDB = FUI.db.global.Details

    local LayoutDropdown = AG:Create("Dropdown")
    LayoutDropdown:SetLabel("Details! Layout")
    LayoutDropdown:SetList({ ["VERTICAL"] = "Vertical", ["HORIZONTAL"] = "Horizontal" }, { "VERTICAL", "HORIZONTAL" })
    LayoutDropdown:SetValue(DetailsDB.Layout)
    LayoutDropdown:SetCallback("OnValueChanged", function(_, _, value) DetailsDB.Layout = value RelayoutDetailsSettings() FUI:UpdateDetailsBackdrop() end)
    LayoutDropdown:SetRelativeWidth(1)
    parentContainer:AddChild(LayoutDropdown)

    local DetailsFrameOneContainer = AG:Create("InlineGroup")
    DetailsFrameOneContainer:SetTitle("Details! Frame One")
    DetailsFrameOneContainer:SetLayout("Flow")
    DetailsFrameOneContainer:SetFullWidth(true)
    parentContainer:AddChild(DetailsFrameOneContainer)

    CreateDetailsLayoutOptions(DetailsFrameOneContainer, DetailsDB.One, function() FUI:UpdateDetailsBackdrop() end)

    local DetailsFrameTwoContainer = AG:Create("InlineGroup")
    DetailsFrameTwoContainer:SetTitle("Details! Frame Two")
    DetailsFrameTwoContainer:SetLayout("Flow")
    DetailsFrameTwoContainer:SetFullWidth(true)
    parentContainer:AddChild(DetailsFrameTwoContainer)

    CreateDetailsLayoutOptions(DetailsFrameTwoContainer, DetailsDB.Two, function() FUI:UpdateDetailsBackdrop() end)

    function RelayoutDetailsSettings()
        DetailsFrameOneContainer:ReleaseChildren()
        DetailsFrameTwoContainer:ReleaseChildren()
        CreateDetailsLayoutOptions(DetailsFrameOneContainer, DetailsDB.One, function() FUI:UpdateDetailsBackdrop() end)
        CreateDetailsLayoutOptions(DetailsFrameTwoContainer, DetailsDB.Two, function() FUI:UpdateDetailsBackdrop() end)
    end
end

local function CreateMailSettings(parentContainer)
    local MailDB = FUI.db.global.Mail
    GUI.Mail = GUI.Mail or {}

    local EnableToggle = AG:Create("CheckBox")
    EnableToggle:SetLabel("Enable")
    EnableToggle:SetValue(MailDB.Enabled)
    EnableToggle:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Enabled = value FUI:UpdateMailIcon() GUI.Mail:UpdateMailSettings() end)
    EnableToggle:SetRelativeWidth(0.5)
    parentContainer:AddChild(EnableToggle)

    local MailTextureDropdown = AG:Create("Dropdown")
    MailTextureDropdown:SetLabel("Mail Texture")
    MailTextureDropdown:SetList({ ["Mail 01"] = "|T" .. FUI.MAIL_TEXTURES["Mail 01"] .. ":16:16|t", ["Mail 02"] = "|T" .. FUI.MAIL_TEXTURES["Mail 02"] .. ":16:16|t", ["Mail 03"] = "|T" .. FUI.MAIL_TEXTURES["Mail 03"] .. ":16:16|t", ["Mail 04"] = "|T" .. FUI.MAIL_TEXTURES["Mail 04"] .. ":16:16|t", ["Mail 05"] = "|T" .. FUI.MAIL_TEXTURES["Mail 05"] .. ":16:16|t" }, { "Mail 01", "Mail 02", "Mail 03", "Mail 04", "Mail 05" })
    MailTextureDropdown:SetValue(MailDB.Texture)
    MailTextureDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Texture = value FUI:UpdateMailIcon() end)
    MailTextureDropdown:SetRelativeWidth(0.5)
    parentContainer:AddChild(MailTextureDropdown)

    local LayoutContainer = AG:Create("InlineGroup")
    LayoutContainer:SetTitle("Layout")
    LayoutContainer:SetLayout("Flow")
    LayoutContainer:SetFullWidth(true)
    parentContainer:AddChild(LayoutContainer)

    local WidthSlider = AG:Create("Slider")
    WidthSlider:SetLabel("Width")
    WidthSlider:SetValue(MailDB.Width)
    WidthSlider:SetSliderValues(12, 32, 1)
    WidthSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Width = value FUI:UpdateMailIcon() end)
    WidthSlider:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(WidthSlider)

    local HeightSlider = AG:Create("Slider")
    HeightSlider:SetLabel("Height")
    HeightSlider:SetValue(MailDB.Height)
    HeightSlider:SetSliderValues(12, 32, 1)
    HeightSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Height = value FUI:UpdateMailIcon() end)
    HeightSlider:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(HeightSlider)

    local AnchorFromDropdown = AG:Create("Dropdown")
    AnchorFromDropdown:SetLabel("Anchor From")
    AnchorFromDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorFromDropdown:SetValue(MailDB.Layout[1])
    AnchorFromDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Layout[1] = value FUI:UpdateMailIcon() end)
    AnchorFromDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorFromDropdown)

    local AnchorToDropdown = AG:Create("Dropdown")
    AnchorToDropdown:SetLabel("Anchor To")
    AnchorToDropdown:SetList(AnchorPoints[1], AnchorPoints[2])
    AnchorToDropdown:SetValue(MailDB.Layout[2])
    AnchorToDropdown:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Layout[2] = value FUI:UpdateMailIcon() end)
    AnchorToDropdown:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(AnchorToDropdown)

    local XOffsetSlider = AG:Create("Slider")
    XOffsetSlider:SetLabel("X Offset")
    XOffsetSlider:SetValue(MailDB.Layout[3])
    XOffsetSlider:SetSliderValues(-500, 500, 1)
    XOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Layout[3] = value FUI:UpdateMailIcon() end)
    XOffsetSlider:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(XOffsetSlider)

    local YOffsetSlider = AG:Create("Slider")
    YOffsetSlider:SetLabel("Y Offset")
    YOffsetSlider:SetValue(MailDB.Layout[4])
    YOffsetSlider:SetSliderValues(-500, 500, 1)
    YOffsetSlider:SetCallback("OnValueChanged", function(_, _, value) FUI.db.global.Mail.Layout[4] = value FUI:UpdateMailIcon() end)
    YOffsetSlider:SetRelativeWidth(0.5)
    LayoutContainer:AddChild(YOffsetSlider)

    local ColourContainer = AG:Create("InlineGroup")
    ColourContainer:SetTitle("Colours")
    ColourContainer:SetLayout("Flow")
    ColourContainer:SetFullWidth(true)
    parentContainer:AddChild(ColourContainer)

    local ColourPicker = AG:Create("ColorPicker")
    ColourPicker:SetLabel("Colour")
    ColourPicker:SetColor(unpack(MailDB.Colour))
    ColourPicker:SetHasAlpha(true)
    ColourPicker:SetCallback("OnValueChanged", function(_, _, r, g, b, a) FUI.db.global.Mail.Colour = { r, g, b, a } FUI:UpdateMailIcon() end)
    ColourPicker:SetRelativeWidth(0.5)
    ColourContainer:AddChild(ColourPicker)

    function GUI.Mail:UpdateMailSettings()
        AnchorFromDropdown:SetDisabled(not FUI.db.global.Mail.Enabled)
        AnchorToDropdown:SetDisabled(not FUI.db.global.Mail.Enabled)
        XOffsetSlider:SetDisabled(not FUI.db.global.Mail.Enabled)
        YOffsetSlider:SetDisabled(not FUI.db.global.Mail.Enabled)
        WidthSlider:SetDisabled(not FUI.db.global.Mail.Enabled)
        HeightSlider:SetDisabled(not FUI.db.global.Mail.Enabled)
        ColourPicker:SetDisabled(not FUI.db.global.Mail.Enabled)
    end

    GUI.Mail:UpdateMailSettings()

    return parentContainer
end

local function CreateQualityOfLifeSettings(parentContainer)
    local QualityOfLifeDB = FUI.db.global.QualityOfLife

    local TogglesContainer = AG:Create("InlineGroup")
    TogglesContainer:SetTitle("Toggles")
    TogglesContainer:SetLayout("Flow")
    TogglesContainer:SetFullWidth(true)
    parentContainer:AddChild(TogglesContainer)

    local SkipCinematicsToggle = AG:Create("CheckBox")
    SkipCinematicsToggle:SetLabel("Skip Cinematics")
    SkipCinematicsToggle:SetDescription("|cFFCCCCCCSkips Cinematics/Cutscenes.|r")
    SkipCinematicsToggle:SetValue(QualityOfLifeDB.SkipCinematics)
    SkipCinematicsToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.SkipCinematics = value FUI:PromptReload() end)
    SkipCinematicsToggle:SetRelativeWidth(1)
    TogglesContainer:AddChild(SkipCinematicsToggle)

    local HideTalkingHeadFrameToggle = AG:Create("CheckBox")
    HideTalkingHeadFrameToggle:SetLabel("Hide Talking Head Frame")
    HideTalkingHeadFrameToggle:SetDescription("|cFFCCCCCCHides Talking Head Frame.|r")
    HideTalkingHeadFrameToggle:SetValue(QualityOfLifeDB.HideTalkingHeadFrame)
    HideTalkingHeadFrameToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.HideTalkingHeadFrame = value FUI:PromptReload() end)
    HideTalkingHeadFrameToggle:SetRelativeWidth(1)
    TogglesContainer:AddChild(HideTalkingHeadFrameToggle)

    local SkipRoleCheckToggle = AG:Create("CheckBox")
    SkipRoleCheckToggle:SetLabel("Skip Role Check")
    SkipRoleCheckToggle:SetDescription("|cFFCCCCCCSkips Role Checks when queueing for Dungeons/Raids.|r")
    SkipRoleCheckToggle:SetValue(QualityOfLifeDB.SkipRoleCheck)
    SkipRoleCheckToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.SkipRoleCheck = value end)
    SkipRoleCheckToggle:SetRelativeWidth(1)
    TogglesContainer:AddChild(SkipRoleCheckToggle)

    local DataTextToggle = AG:Create("CheckBox")
    DataTextToggle:SetLabel("Enable Data Texts")
    DataTextToggle:SetDescription("|cFFCCCCCCEnables |cFF8080FFFriends|r & |cFF8080FFGuild|r Data Texts below the Minimap.|r")
    DataTextToggle:SetValue(QualityOfLifeDB.DataTexts)
    DataTextToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.DataTexts = value FUI:UpdateDataTexts() end)
    DataTextToggle:SetRelativeWidth(1)
    TogglesContainer:AddChild(DataTextToggle)

    local HideDurabilityFrame = AG:Create("CheckBox")
    HideDurabilityFrame:SetLabel("Enable Durability Frame")
    HideDurabilityFrame:SetDescription("|cFFCCCCCCEnable Durability Frame on the Character Panel.|r")
    HideDurabilityFrame:SetValue(QualityOfLifeDB.DurabilityFrame)
    HideDurabilityFrame:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.DurabilityFrame = value FUI:PromptReload() end)
    HideDurabilityFrame:SetRelativeWidth(1)
    TogglesContainer:AddChild(HideDurabilityFrame)

    if not C_AddOns.IsAddOnLoaded("BetterCharacterPanel") then
        CreateInformationTag(TogglesContainer, "|cFF8080FFBetterCharacterPanel|r can be installed to display |cFFFFCC00Item Level|r, |cFFFFCC00Gems|r and |cFFFFCC00Enchants|r on the Character Panel.")
    end

    local AutoSellRepairContainer = AG:Create("InlineGroup")
    AutoSellRepairContainer:SetTitle("Auto Sell Junk & Repair")
    AutoSellRepairContainer:SetLayout("Flow")
    AutoSellRepairContainer:SetFullWidth(true)
    parentContainer:AddChild(AutoSellRepairContainer)

    local SellGreysToggle = AG:Create("CheckBox")
    SellGreysToggle:SetLabel("Sell Greys")
    SellGreysToggle:SetDescription("|cFFCCCCCCAutomatically Sells Grey Items When Visiting a Merchant.|r")
    SellGreysToggle:SetValue(QualityOfLifeDB.AutoSellRepair.SellGreys)
    SellGreysToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.AutoSellRepair.SellGreys = value end)
    SellGreysToggle:SetRelativeWidth(1)
    AutoSellRepairContainer:AddChild(SellGreysToggle)

    local AutoRepairToggle = AG:Create("CheckBox")
    AutoRepairToggle:SetLabel("Auto Repair")
    AutoRepairToggle:SetDescription("|cFFCCCCCCAutomatically Repairs When Visiting a Merchant.|r")
    AutoRepairToggle:SetValue(QualityOfLifeDB.AutoSellRepair.AutoRepair)
    AutoRepairToggle:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.AutoSellRepair.AutoRepair = value end)
    AutoRepairToggle:SetRelativeWidth(1)
    AutoSellRepairContainer:AddChild(AutoRepairToggle)

    local RepairMethodDropdown = AG:Create("Dropdown")
    RepairMethodDropdown:SetLabel("Repair Funds")
    RepairMethodDropdown:SetList({ PERSONAL = "Personal Funds", GUILD = "Guild Funds", BOTH = "Guild Funds, then Personal Funds" }, { "PERSONAL", "GUILD", "BOTH" })
    RepairMethodDropdown:SetValue(QualityOfLifeDB.AutoSellRepair.RepairMethod)
    RepairMethodDropdown:SetCallback("OnValueChanged", function(_, _, value) QualityOfLifeDB.AutoSellRepair.RepairMethod = value end)
    RepairMethodDropdown:SetRelativeWidth(1)
    AutoSellRepairContainer:AddChild(RepairMethodDropdown)



    return parentContainer
end

local function CreateProfileImportSettings(parentContainer)

    local GeneralAddOnsProfiles = {
        ["BasicMinimap"] = "f9u0UnmimWVOkbjHqYRrtBRVqMk5zlrdKoRMbtGR0u)6Nd7H9M9D(oFhiHfWU62drVlprrWAsXayZop(Oagby)clfmflWv(Yuk7Rtzh6Fb32oVMIvMSBJW4T5SpKpak4ZayKdSdxthG2kqdBOd3pUypTEhMyP1bg47ubj(vCMmsWUm)XLZV9(sv0)lTWRN0kXyJyOx21ku6rbSDs1aMoMQxR0dsvBVqQg1D9)rrGLYU17CcRT8cE7tA6br83Sp5kVe(H4mqa87p",
        ["LS: Toasts"] = "1wv3oUYjm4NOtfW8)Ln60wvPJYUsZk17ye7mKe0sgYbiz30N(Aat2nrPDt0QMCbEm2(Z(ZyGt5pX7DERWl49F)p)1F8WFW7piToLzMVKYiHFvGjVOM59RSI17v8EX84gJ1b(UmgGvIjPzVFysQfh5lz8(Dg1SpSf853kOGM34llRGiTJ3)0dp(JF73HnTp((hEaKrHwYxs(LwE)wXBdIrV6GCWBeoVJVe0U2AE1VzWSALt6hGyxEs3KYkb7H0U)7p8xlV0waEwnacaZktk1CQ)wgQXGUrJovq9(nwPBJrpfQT(Nn2jPLVG3RgnZd4NpZ7NfBLWk4Q)4oz0tTX4hg3BTY5XJbfYzXZA5uW7dREl4108uyXbFTitJrC8gJ2R2f0cnJXxg0gNly6kL2ltuDbRTeyNqHurscTKUOaTI0gfaBQtcfuCRosnAmuQrnuwhACxkofussG2YAZgxLeiKIOqllTsznjbwvhMoSYKT0gAlAddZccMx0QAs2gmVAQBYbeHIIquHy30Gw0WOrHUYsScQtXVPih(wm8DOpqENPMcmXBXkH2vqZv7jVqgHwMZokblBeY22CwIfzbPcj2t5j4ogpcsnzmH(csSKICxaHQGGDbOTK1GDH6C8yyIwWYmCrjggwnQPPd08nAO1xJGw0G7rRWounHLbfjJM8wT0OM4is8OSBNCuj0xCswPpOdRA5AX4Xb5p3R2Tvctulo7u8NEG)9XSIaIWWRAN8cSULXfeiTCfm8PvJVKMkxlSwLdgzBhiFmQyoT4MIAMjgnB3cxS8)nra3s(Z9sN)85(ydXUFwokShuZRVs1CBCu6AonEl5nY0)l07RglKX3vmaV2y27UJk4KFNAM1FTMz8bfLxLUV(UsD1SZd6V5tOFaZnk5bz8KXv9965SuyNtv47rYoUriHhQwF5Rl31zGtKz3xJmDEJ9MPJpFGnoOT2C(PQ)ZZ3N9o55pBFiA9hl2MVwXcGn72AwFR171lYWF()a",
    }

    local GeneralAddOnsContainer = AG:Create("InlineGroup")
    GeneralAddOnsContainer:SetTitle("General")
    GeneralAddOnsContainer:SetLayout("Flow")
    GeneralAddOnsContainer:SetFullWidth(true)
    parentContainer:AddChild(GeneralAddOnsContainer)

    local BasicMinimapProfileImportButton = AG:Create("Button")
    BasicMinimapProfileImportButton:SetText("|T134269:18:18|t BasicMinimap")
    BasicMinimapProfileImportButton:SetHeight(36)
    BasicMinimapProfileImportButton:SetRelativeWidth(0.5)
    BasicMinimapProfileImportButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    BasicMinimapProfileImportButton.frame.Text:SetShadowColor(0,0,0,0)
    BasicMinimapProfileImportButton:SetCallback("OnClick", function() FUI:ImportProfile(GeneralAddOnsProfiles["BasicMinimap"], "BasicMinimap") end)
    BasicMinimapProfileImportButton:SetCallback("OnEnter", function() GameTooltip:SetOwner(BasicMinimapProfileImportButton.frame, "ANCHOR_CURSOR") GameTooltip:SetText("|cFFFFFFFFCurrent Profile:|r |cFF8080FF" .. FUI:FetchCurrentProfileForAddOn("BasicMinimap") .. "|r") GameTooltip:Show() end)
    BasicMinimapProfileImportButton:SetCallback("OnLeave", function() GameTooltip:Hide() end)
    BasicMinimapProfileImportButton:SetDisabled(not C_AddOns.IsAddOnLoaded("BasicMinimap"))
    GeneralAddOnsContainer:AddChild(BasicMinimapProfileImportButton)

    local LSToastsProfileImportButton = AG:Create("Button")
    LSToastsProfileImportButton:SetText("|TInterface\\AddOns\\ls_Toasts\\assets\\logo-64:18:18|t LS: Toasts")
    LSToastsProfileImportButton:SetHeight(36)
    LSToastsProfileImportButton:SetRelativeWidth(0.5)
    LSToastsProfileImportButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    LSToastsProfileImportButton.frame.Text:SetShadowColor(0,0,0,0)
    LSToastsProfileImportButton:SetCallback("OnClick", function() FUI:ImportProfile(GeneralAddOnsProfiles["LS: Toasts"], "ls_Toasts") end)
    LSToastsProfileImportButton:SetCallback("OnEnter", function() GameTooltip:SetOwner(LSToastsProfileImportButton.frame, "ANCHOR_CURSOR") GameTooltip:SetText("|cFFFFFFFFCurrent Profile:|r |cFF8080FF" .. FUI:FetchCurrentProfileForAddOn("ls_Toasts") .. "|r") GameTooltip:Show() end)
    LSToastsProfileImportButton:SetCallback("OnLeave", function() GameTooltip:Hide() end)
    LSToastsProfileImportButton:SetDisabled(not C_AddOns.IsAddOnLoaded("ls_Toasts"))
    GeneralAddOnsContainer:AddChild(LSToastsProfileImportButton)

    if FUI.DEVELOPER_MODE == true then
        local DevContainer = AG:Create("InlineGroup")
        DevContainer:SetTitle("Developer Tools")
        DevContainer:SetLayout("Flow")
        DevContainer:SetFullWidth(true)
        parentContainer:AddChild(DevContainer)

        local ExportBasicMinimapButton = AG:Create("Button")
        ExportBasicMinimapButton:SetText("Export |T134269:18:18|t BasicMinimap Profile")
        ExportBasicMinimapButton:SetHeight(36)
        ExportBasicMinimapButton:SetRelativeWidth(0.5)
        ExportBasicMinimapButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        ExportBasicMinimapButton.frame.Text:SetShadowColor(0,0,0,0)
        ExportBasicMinimapButton:SetCallback("OnClick", function() FUI:ExportProfile("BasicMinimap") end)
        DevContainer:AddChild(ExportBasicMinimapButton)

        local ExportLSToastsButton = AG:Create("Button")
        ExportLSToastsButton:SetText("Export |TInterface\\AddOns\\ls_Toasts\\assets\\logo-64:18:18|t LS: Toasts Profile")
        ExportLSToastsButton:SetHeight(36)
        ExportLSToastsButton:SetRelativeWidth(0.5)
        ExportLSToastsButton.frame.Text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
        ExportLSToastsButton.frame.Text:SetShadowColor(0,0,0,0)
        ExportLSToastsButton:SetCallback("OnClick", function() FUI:ExportProfile("ls_Toasts") end)
        DevContainer:AddChild(ExportLSToastsButton)
    end

    return parentContainer
end

function FUI:CreateGUI()
    if isGUIOpen then return end
    if InCombatLockdown() then return end

    isGUIOpen = true

    Container = AG:Create("Frame")
    Container:SetTitle(FUI.LOGO .. "|cFF8080FFFrag|rUI")
    Container:SetLayout("Fill")
    Container:SetWidth(700)
    Container:SetHeight(700)
    Container:EnableResize(false)
    Container:SetCallback("OnClose", function(widget) AG:Release(widget) isGUIOpen = false HideElements() end)

    local function SelectTab(GUIContainer, _, MainTab)
        GUIContainer:ReleaseChildren()

        local Wrapper = AG:Create("SimpleGroup")
        Wrapper:SetFullWidth(true)
        Wrapper:SetFullHeight(true)
        Wrapper:SetLayout("Fill")
        GUIContainer:AddChild(Wrapper)

        if MainTab == "Skinning" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateSkinningSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "Chat" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateChatSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "CombatAlert" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateCombatAlertSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "Crosshair" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateCrosshairSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "CVars" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateCVarsSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "Details" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateDetailsSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "Mail" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateMailSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "QualityOfLife" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateQualityOfLifeSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        elseif MainTab == "ProfileImport" then
            local ScrollFrame = AG:Create("ScrollFrame")
            ScrollFrame:SetLayout("Flow")
            ScrollFrame:SetFullWidth(true)
            ScrollFrame:SetFullHeight(true)
            Wrapper:AddChild(ScrollFrame)

            CreateProfileImportSettings(ScrollFrame)

            ScrollFrame:DoLayout()
        end

        if MainTab ~= "CombatAlert" then FUI.CombatAlertFrame:SetAlpha(0) end

    end

    local ContainerTabGroup = AG:Create("TabGroup")
    ContainerTabGroup:SetLayout("Flow")
    ContainerTabGroup:SetFullWidth(true)
    ContainerTabGroup:SetTabs({
        { text = "Skinning", value = "Skinning"},
        { text = "Chat", value = "Chat" },
        { text = "Combat Alert", value = "CombatAlert"},
        { text = "Crosshair", value = "Crosshair"},
        { text = "CVars", value = "CVars"},
        { text = "Details! Damage Meter", value = "Details"},
        { text = "Mail", value = "Mail"},
        { text = "Quality of Life", value = "QualityOfLife"},
        { text = "Profile Import", value = "ProfileImport"},
    })
    ContainerTabGroup:SetCallback("OnGroupSelected", SelectTab)
    ContainerTabGroup:SelectTab("Skinning")
    Container:AddChild(ContainerTabGroup)
end

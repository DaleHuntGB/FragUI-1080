local _, FUI = ...

local Minimap = _G.Minimap
local MinimapCluster = _G.MinimapCluster
local PlayerSpellsUtil = _G.PlayerSpellsUtil

local IsEncounterJournalLoaded = C_AddOns and C_AddOns.IsAddOnLoaded

local menuRoot = CreateFrame("Frame", "FUI_MinimapContextMenu", UIParent, "UIDropDownMenuTemplate")

local function Localized(globalName, fallback)
    local text = _G[globalName]
    if type(text) == "string" and text ~= "" then
        return text
    end

    return fallback
end

local function ClickGlobalButton(buttonName)
    local button = _G[buttonName]
    if button and button.Click then
        button:Click()
        return true
    end

    return false
end

local function OpenTrackingMenu()
    local modernTracking = MinimapCluster and MinimapCluster.Tracking
    local modernButton = modernTracking and modernTracking.Button

    if modernButton and modernButton.OpenMenu then
        modernButton:OpenMenu()
        return
    end

    if modernTracking and modernTracking.Dropdown then
        ToggleDropDownMenu(1, nil, modernTracking.Dropdown, "cursor")
        return
    end

    if _G.MiniMapTrackingDropDown then
        ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, "cursor")
        return
    end

    ClickGlobalButton("MiniMapTrackingButton")
end

local function OpenCharacter()
    if ClickGlobalButton("CharacterMicroButton") then
        return
    end

    if _G.ToggleCharacter then
        _G.ToggleCharacter("PaperDollFrame")
    end
end

local function OpenSpellbook()
    if ClickGlobalButton("SpellbookMicroButton") then
        return
    end

    if PlayerSpellsUtil and PlayerSpellsUtil.ToggleSpellBookFrame then
        PlayerSpellsUtil.ToggleSpellBookFrame()
    elseif _G.SpellBookFrame then
        ToggleFrame(_G.SpellBookFrame)
    end
end

local function OpenTalents()
    if ClickGlobalButton("TalentMicroButton") then
        return
    end

    if PlayerSpellsUtil and PlayerSpellsUtil.ToggleClassTalentFrame then
        PlayerSpellsUtil.ToggleClassTalentFrame()
    elseif _G.ToggleTalentFrame then
        _G.ToggleTalentFrame()
    end
end

local function OpenGuild()
    if ClickGlobalButton("GuildMicroButton") then
        return
    end

    if _G.ToggleGuildFrame then
        _G.ToggleGuildFrame()
    end
end

local function OpenSocial()
    if ClickGlobalButton("SocialsMicroButton") then
        return
    end

    if _G.ToggleFriendsFrame then
        _G.ToggleFriendsFrame()
    end
end

local function OpenCollections()
    if ClickGlobalButton("CollectionsMicroButton") then
        return
    end

    if _G.ToggleCollectionsJournal then
        _G.ToggleCollectionsJournal()
    end
end

local function OpenAchievements()
    if ClickGlobalButton("AchievementMicroButton") then
        return
    end

    if _G.ToggleAchievementFrame then
        _G.ToggleAchievementFrame()
    end
end

local function OpenGroupFinder()
    if ClickGlobalButton("LFDMicroButton") then
        return
    end

    if _G.ToggleLFDParentFrame then
        _G.ToggleLFDParentFrame()
    elseif _G.PVEFrame_ToggleFrame then
        _G.PVEFrame_ToggleFrame()
    end
end

local function OpenEncounterJournal()
    if ClickGlobalButton("EJMicroButton") then
        return
    end

    if IsEncounterJournalLoaded and not IsEncounterJournalLoaded("Blizzard_EncounterJournal") then
        UIParentLoadAddOn("Blizzard_EncounterJournal")
    end

    if _G.EncounterJournal then
        ToggleFrame(_G.EncounterJournal)
    end
end

local function OpenProfessions()
    if ClickGlobalButton("ProfessionMicroButton") then
        return
    end

    if _G.ToggleProfessionsBook then
        _G.ToggleProfessionsBook()
    end
end

local function OpenQuestLog()
    if ClickGlobalButton("QuestLogMicroButton") then
        return
    end

    if _G.ToggleQuestLog then
        _G.ToggleQuestLog()
    elseif _G.QuestLogFrame then
        ToggleFrame(_G.QuestLogFrame)
    end
end

local ACTIONS = {
    { label = function() return Localized("CHARACTER_BUTTON", "Character") end, run = OpenCharacter },
    { label = function() return Localized("SPELLBOOK", Localized("SPELLBOOK_ABILITIES_BUTTON", "Spellbook")) end, run = OpenSpellbook },
    { label = function() return Localized("TALENTS_BUTTON", "Talents") end, run = OpenTalents },
    { label = function() return Localized("PROFESSIONS_BUTTON", "Professions") end, run = OpenProfessions },
    { label = function() return Localized("QUESTLOG_BUTTON", Localized("QUEST_LOG", "Quest Log")) end, run = OpenQuestLog },
    { separator = true },
    { label = function() return Localized("SOCIAL_BUTTON", "Social") end, run = OpenSocial },
    { label = function() return Localized("GUILD", "Guild") end, run = OpenGuild },
    { separator = true },
    { label = function() return Localized("COLLECTIONS", "Collections") end, run = OpenCollections },
    { label = function() return Localized("ACHIEVEMENT_BUTTON", "Achievements") end, run = OpenAchievements },
    { label = function() return Localized("LFG_TITLE", "Group Finder") end, run = OpenGroupFinder },
    { label = function() return Localized("ENCOUNTER_JOURNAL", "Encounter Journal") end, run = OpenEncounterJournal },
}

local function NewDropdownRow()
    return UIDropDownMenu_CreateInfo and UIDropDownMenu_CreateInfo() or {}
end

local function AddActionToMenu(action, level)
    local info = NewDropdownRow()

    if action.separator then
        info.disabled = true
        info.notCheckable = true
        info.isTitle = true
        info.text = " "
    else
        info.notCheckable = true
        info.text = action.label()
        info.func = function()
            menuRoot:Hide()
            action.run()
        end
    end

    UIDropDownMenu_AddButton(info, level)
end

local function OpenMicroMenu()
    menuRoot:Hide()

    local fixedAnchor = CreateFrame("Frame", "FUI_MinimapMenuAnchor", UIParent)
    fixedAnchor:SetSize(1, 1)
    fixedAnchor:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", -1, 1)

    UIDropDownMenu_Initialize(menuRoot, function(_, level) if level ~= 1 then return end for i = 1, #ACTIONS do AddActionToMenu(ACTIONS[i], level) end end, "MENU")

    ToggleDropDownMenu(1, nil, menuRoot, fixedAnchor, 0, 0)
end

local function HandleMinimapMouseDown(_, button)
    if button == "MiddleButton" then
        OpenMicroMenu()
        return
    end

    if button == "RightButton" and IsShiftKeyDown() then
        OpenMicroMenu()
        return
    end

    if button == "RightButton" then
        OpenTrackingMenu()
    end
end

function FUI:SetupMicroMenu()
    if not Minimap or self.MinimapMicroCapture then return end

    local capture = CreateFrame("Frame", "FUI_MinimapInputCapture", Minimap)
    capture:SetAllPoints(Minimap)
    capture:SetFrameStrata("DIALOG")
    capture:SetFrameLevel((Minimap:GetFrameLevel() or 1) + 10)
    capture:EnableMouse(true)

    if capture.SetPassThroughButtons then
        capture:SetPassThroughButtons("LeftButton")
        capture:SetScript("OnMouseDown", HandleMinimapMouseDown)
    else
        capture:EnableMouse(false)
        Minimap:HookScript("OnMouseDown", function(_, button) if button == "MiddleButton" then OpenMicroMenu() end end)
    end

    self.MinimapMicroCapture = capture
end

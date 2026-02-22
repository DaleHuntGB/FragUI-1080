local _, FUI = ...

FUI.INFOBUTTON = "|TInterface\\AddOns\\FragUI\\Media\\Textures\\InfoButton.png:16:16|t "
FUI.LOGO = "|TInterface\\AddOns\\FragUI\\Media\\Textures\\Logo_Small.png:16:16|t "
FUI.DEVELOPER_MODE = false

FUI.LSM = LibStub("LibSharedMedia-3.0")

FUI.LSM:Register("font", "Pepsi", "Interface\\AddOns\\FragUI\\Media\\Fonts\\Pepsi.ttf")

FUI.PLAYER_CLASS = select(2, UnitClass("player"))
FUI.PLAYER_CLASS_COLOR = RAID_CLASS_COLORS[FUI.PLAYER_CLASS]
FUI.PLAYER_CLASS_COLOR_HEX = CreateColor(FUI.PLAYER_CLASS_COLOR.r, FUI.PLAYER_CLASS_COLOR.g, FUI.PLAYER_CLASS_COLOR.b):GenerateHexColor()

function FUI:FetchClassColour(unitClass)
    local classColor = RAID_CLASS_COLORS[unitClass:gsub(" ", ""):upper()]
    if classColor then
        return CreateColor(classColor.r, classColor.g, classColor.b):GenerateHexColor()
    else
        return "FFFFFFFF"
    end
end

StaticPopupDialogs["FRAGUI_RELOAD"] = {
    text = "You must |cFFFF4040reload|r in order for changes to take effect. Do you want to reload now?",
    button1 = "Reload",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    OnCancel = function() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    showAlert = true,
}

FUI.CROSSHAIR_TEXTURES = {
    ["Plus"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Crosshair_01.png",
    ["CircleCircle"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Crosshair_02.png",
    ["Dot"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Crosshair_03.png",
    ["Circle"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Crosshair_04.png",
    ["Diamond"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Crosshair_05.png",
}

FUI.MAIL_TEXTURES = {
    ["Mail 01"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Mail_01.png",
    ["Mail 02"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Mail_02.png",
    ["Mail 03"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Mail_03.png",
    ["Mail 04"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Mail_04.png",
    ["Mail 05"] = "Interface\\AddOns\\FragUI\\Media\\Textures\\Mail_05.png",
}

FUI.MOUSE_CURSOR_TEXTURES = {
    ["Cursor 01"] = "talents-search-notonactionbar",
    ["Cursor 02"] = "talents-search-notonactionbarhidden",
}

local SHADOW_OPTIONS = {
    [0] = "Low",
    [1] = "Fair",
    [2] = "Good",
    [3] = "High",
    [4] = "Ultra",
    [5] = "Ultra High"
}

local LIQUID_DETAIL = {
    [0] = "Low",
    [1] = "Fair",
    [2] = "Good",
    [3] = "High",
}

local PARTICLE_DENSITY = {
    [0] = "Disabled",
    [1] = "Low",
    [2] = "Fair",
    [3] = "Good",
    [4] = "High",
    [5] = "Ultra",
}

local SSAO = {
    [0] = "Disabled",
    [1] = "Low",
    [2] = "Good",
    [3] = "High",
    [4] = "Ultra",
}

local DEPTH_EFFECTS = {
    [0] = "Disabled",
    [1] = "Low",
    [2] = "Good",
    [3] = "High",
}

local COMPUTE_EFFECTS = {
    [0] = "Disabled",
    [1] = "Low",
    [2] = "Good",
    [3] = "High",
    [4] = "Ultra",
}

local TEXTURE_RESOLUTION = {
    [0] = "Low",
    [1] = "Fair",
    [2] = "High",
}

local SPELL_DENSITY = {
    [0] = "Essential",
    [1] = "Reduced",
    [2] = "Everything",
}

local PROJECTED_TEXTURES = {
    [0] = "Disabled",
    [1] = "Enabled",
}

local USE_TARGET_FPS = {
    [0] = "Disabled",
    [1] = "Enabled",
}

local GraphicsCVars = {
    ["graphicsQuality"] = {OPTIMAL = 9, NICENAME = "Graphics Quality", ORDER = 1},
    ["graphicsShadowQuality"] = {OPTIMAL = 3, NICENAME = "Shadow Quality", ORDER = 2, OPTIONS = SHADOW_OPTIONS},
    ["graphicsLiquidDetail"] = {OPTIMAL = 2, NICENAME = "Liquid Detail", ORDER = 3, OPTIONS = LIQUID_DETAIL},
    ["graphicsParticleDensity"] = {OPTIMAL = 4, NICENAME = "Particle Density", ORDER = 5, OPTIONS = PARTICLE_DENSITY},
    ["graphicsSSAO"] = {OPTIMAL = 0, NICENAME = "SSAO", ORDER = 5, OPTIONS = SSAO},
    ["graphicsDepthEffects"] = {OPTIMAL = 0, NICENAME = "Depth Effects", ORDER = 6, OPTIONS = DEPTH_EFFECTS},
    ["graphicsComputeEffects"] = {OPTIMAL = 0, NICENAME = "Compute Effects", ORDER = 7, OPTIONS = COMPUTE_EFFECTS},
    ["graphicsTextureResolution"] = {OPTIMAL = 2, NICENAME = "Texture Resolution", ORDER = 8, OPTIONS = TEXTURE_RESOLUTION},
    ["graphicsSpellDensity"] = {OPTIMAL = 0, NICENAME = "Spell Density", ORDER = 9, OPTIONS = SPELL_DENSITY},
    ["graphicsProjectedTextures"] = {OPTIMAL = 1, NICENAME = "Projected Textures", ORDER = 10, OPTIONS = PROJECTED_TEXTURES},
    ["graphicsViewDistance"] = {OPTIMAL = 6, NICENAME = "View Distance", ORDER = 11},
    ["graphicsEnvironmentDetail"] = {OPTIMAL = 0, NICENAME = "Environment Detail", ORDER = 12},
    ["graphicsGroundClutter"] = {OPTIMAL = 0, NICENAME = "Ground Clutter", ORDER = 13},
    ["useTargetFPS"] = {OPTIMAL = 0, NICENAME = "Use Target FPS", ORDER = 14, OPTIONS = USE_TARGET_FPS},
}

function FUI:SetupSlashCommands()
    SLASH_FRAGUI1 = "/fragui"
    SLASH_FRAGUI2 = "/fui"
    SlashCmdList["FRAGUI"] = function(MSG)
        if MSG == "" then
            FUI:CreateGUI()
            FUI.DEVELOPER_MODE = false
        elseif MSG == "dev" then
            FUI:CreateGUI()
            FUI.DEVELOPER_MODE = true
        end
    end
end

function FUI:SetJustification(anchorFrom)
    if anchorFrom == "TOPLEFT" or anchorFrom == "LEFT" or anchorFrom == "BOTTOMLEFT" then
        return "LEFT"
    elseif anchorFrom == "TOPRIGHT" or anchorFrom == "RIGHT" or anchorFrom == "BOTTOMRIGHT" then
        return "RIGHT"
    else
        return "CENTER"
    end
end

function FUI:PrettyPrint(MSG)
    print(FUI.LOGO .. "|cFF8080FFFragUI:|r " .. MSG)
end

function FUI:PromptReload()
    StaticPopup_Show("FRAGUI_RELOAD")
end

function FUI:BackupGraphicsSettings()
    for cVar, _ in pairs(GraphicsCVars) do
        local currentValue = C_CVar.GetCVar(cVar)
        FUI.db.global.GraphicSettingsBackup[cVar] = currentValue
        FUI.db.global.GraphicSettingsBackup.hasBeenBackedUp = true
    end
end

function FUI:SetupGraphics()
    local delayApplication = 0
    for cVar, cVarValues in pairs(GraphicsCVars) do
        delayApplication = delayApplication + 0.2
        C_Timer.After(delayApplication, function()
            C_CVar.SetCVar(cVar, cVarValues.OPTIMAL)
            FUI:PrettyPrint("|cFF8080FF" .. cVarValues.NICENAME .. "|r to |cFF40FF40Optimal|r (" .. cVarValues.OPTIMAL .. ")")
        end)
    end
end

function FUI:RestoreGraphics()
    for cVar, cVarValues in pairs(GraphicsCVars) do
        local backupValue = FUI.db.global.GraphicSettingsBackup[cVar]
        local delayApplication = 0
        if backupValue then
            delayApplication = delayApplication + 0.2
            C_Timer.After(delayApplication, function()
                C_CVar.SetCVar(cVar, backupValue)
                FUI:PrettyPrint("Restored |cFF8080FF" .. cVarValues.NICENAME .. "|r to |cFF40FF40" .. backupValue .. "|r")
            end)
        else
            FUI:PrettyPrint("No backup found for |cFF8080FF" .. cVarValues.NICENAME .. "|r, skipping restore.")
        end
    end
end

function FUI:FetchGraphicsOptionsForTooltip()
    local sortedGraphicsCVars = {}
    for cVar, cVarValues in pairs(GraphicsCVars) do table.insert(sortedGraphicsCVars, {cVar = cVar, values = cVarValues}) end
    table.sort(sortedGraphicsCVars, function(a, b) return a.values.ORDER < b.values.ORDER end)

    local tooltipText = "|cFF8080FFGraphics Options|r\n"

    for _, cVarOrder in ipairs(sortedGraphicsCVars) do
        local cVar = cVarOrder.cVar
        local cVarValues = cVarOrder.values
        local cVarCurrentValue = C_CVar.GetCVar(cVar)
        local cVarOptimalValue = cVarValues.OPTIMAL
        local cVarNiceName = cVarValues.NICENAME

        local cVarOptions = cVarValues.OPTIONS
        if cVarOptions then
            cVarCurrentValue = cVarOptions[tonumber(cVarCurrentValue)] or cVarCurrentValue
            cVarOptimalValue = cVarOptions[tonumber(cVarOptimalValue)] or cVarOptimalValue
        end

        local isOptimal = tostring(cVarCurrentValue) == tostring(cVarOptimalValue)
        local cVarStatus = isOptimal and "|cFF40FF40Optimal|r" or "|cFFFF4040Not Optimal|r"

        tooltipText = tooltipText .. "|cFFFFCC00" .. cVarNiceName .. "|r: " .. "|cFFFFFFFF" .. cVarCurrentValue .. "|r " .. "(" .. cVarStatus .. ")\n"
    end

    return tooltipText
end

function FUI:ResolveLSM()
    local LSM = FUI.LSM
    FUI.Media = FUI.Media or {}
    FUI.Media.Font = LSM:Fetch("font", FUI.db.global.Fonts.Font) or STANDARD_TEXT_FONT
    FUI.Media.FontFlag = FUI.db.global.Fonts.FontFlag or "OUTLINE"
    -- FUI.Media.DamageFont = LSM:Fetch("font", FUI.db.global.Fonts.DamageFont) or DAMAGE_TEXT_FONT
    -- _G.DAMAGE_TEXT_FONT = FUI.Media.DamageFont
    -- _G.CombatTextFont = FUI.Media.DamageFont
    FUI.Backdrop = { bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0} }
end
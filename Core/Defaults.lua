local _, FUI = ...

local Defaults = {
    global = {
        Fonts = {
            Font = "Friz Quadrata TT",
            DamageFont = "Pepsi",
            FontFlag = "OUTLINE",
        },
        GraphicSettingsBackup = {
            hasBeenBackedUp = false,
            ["graphicsQuality"] = nil,
            ["graphicsShadowQuality"] = nil,
            ["graphicsLiquidDetail"] = nil,
            ["graphicsParticleDensity"] = nil,
            ["graphicsSSAO"] = nil,
            ["graphicsDepthEffects"] = nil,
            ["graphicsComputeEffects"] = nil,
            ["graphicsTextureResolution"] = nil,
            ["graphicsSpellDensity"] = nil,
            ["graphicsProjectedTextures"] = nil,
            ["graphicsViewDistance"] = nil,
            ["graphicsEnvironmentDetail"] = nil,
            ["graphicsGroundClutter"] = nil,
            ["useTargetFPS"] = nil,
        },
        Skinning = {
            SkinAuras = true,
            SkinActionBars = true,
            HideBlizzardTextures = true,
            SkinMicroMenu = false,
            UIErrorsFrame = {
                Enabled = true,
                FontSize = 12,
                Layout = {"CENTER", "CENTER", 0, 75},
            },
            ActionStatus = {
                FontSize = 12,
                Layout = {"CENTER", "CENTER", 0, 25},
            },
            ChatBubbleFont = {
                FontSize = 8,
            },
            ObjectiveTracker = {
                Header = {
                    FontSize = 13
                },
                Text = {
                    FontSize = 11
                }
            }
        },
        Chat = {
            SkinChat = true,
            Width = 454,
            Height = 180,
            EnableBackdrop = false,
            Layout = {"BOTTOMLEFT", "BOTTOMLEFT", 1, 1 },
            Colour = { 26/255, 26/255, 26/255, 1 },
        },
        CombatAlert = {
            Enabled = true,
            FontSize = 8,
            Layout = {"CENTER", "CENTER", 0, 75},
            InCombatColour = { 255/255, 64/255, 64/255, 1 },
            OutOfCombatColour = { 64/255, 255/255, 64/255, 1},
            Text = { "+Combat", "-Combat"}
        },
        Crosshair = {
            Enabled = false,
            ShowInCombatOnly = false,
            Layout = {"CENTER", "CENTER", 0, 0},
            Colour = { 255/255, 255/255, 255/255, 1 },
            Size = 16,
            Texture = "Plus",
        },
        CVars = {
            ApplyGlobally = false,
            Values = {
                floatingCombatTextFloatMode_v2 = nil,
                floatingCombatTextCombatDamage_v2 = nil,
                floatingCombatTextCombatHealing_v2 = nil,
                floatingCombatTextReactives_v2 = nil,
                findYourselfModeOutline = nil,
                occludedSilhouettePlayer = nil,
                ffxDeath = nil,
                ffxGlow = nil,
                ResampleAlwaysSharpen = nil,
                autoLootDefault = nil,
                autoLootRate = nil,
                externalDefensivesEnabled = nil,
                nameplateShowOnlyNameForFriendlyPlayerUnits = nil,
                nameplateUseClassColorForFriendlyPlayerUnitNames = nil,
                SpellQueueWindow = nil,
                RAIDWaterDetail = nil,
                RAIDweatherDensity = nil,
            },
        },
        Details = {
            Layout = "VERTICAL",
            One = {
                Enabled = true,
                Width = 222,
                VerticalRows = 6,
                HorizontalRows = 6,
                VerticalLayout = {"BOTTOMRIGHT", "BOTTOMRIGHT", -1, 1},
                HorizontalLayout = {"BOTTOMRIGHT", "BOTTOMRIGHT", -1, 1},
                Colour = { 26/255, 26/255, 26/255, 1 },
            },
            Two = {
                Enabled = true,
                Width = 222,
                VerticalRows = 4,
                HorizontalRows = 6,
                VerticalLayout = {"BOTTOMRIGHT", "BOTTOMRIGHT", -1, 208},
                HorizontalLayout = {"BOTTOMRIGHT", "BOTTOMRIGHT", -224, -1},
                Colour = { 26/255, 26/255, 26/255, 1 },
            },
        },
        Mail = {
            Enabled = true,
            Width = 18,
            Height = 14,
            Layout = {"TOPRIGHT", "TOPRIGHT", -20, -3},
            Texture = "Mail 03",
            Colour = { 255/255, 255/255, 255/255, 1 },
        },
        MouseCursor = {
            Enabled = true,
            Height = 90,
            Width = 90,
            Texture = "Cursor 01",
        },
        QualityOfLife = {
            SkipCinematics = true,
            HideTalkingHeadFrame = true,
            SkipRoleCheck = true,
            AutoSellRepair = {
                SellGreys = true,
                AutoRepair = true,
                RepairMethod = "PERSONAL"
            },
            DataTexts = true,
            DurabilityFrame = false,
        }
    }
}

function FUI:GetDefaultDB()
    return Defaults
end
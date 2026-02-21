local _, FUI = ...
local Serialize = LibStub:GetLibrary("AceSerializer-3.0")
local Compress = LibStub:GetLibrary("LibDeflate")

function FUI:ImportProfile(importString, addOnName)
    if addOnName == "BasicMinimap" then
        if not C_AddOns.IsAddOnLoaded("BasicMinimap") then FUI:PrettyPrint("BasicMinimap cannot be found. Please ensure it is |cFF40FF41installed|r/|cFF40FF40enabled|r.") return end
        local DecodedData = Compress:DecodeForPrint(importString)
        local DecompressedData = Compress:DecompressDeflate(DecodedData)
        local _, BasicMinimapData = Serialize:Deserialize(DecompressedData)
        BasicMinimapSV.profiles = BasicMinimapSV.profiles or {}
        BasicMinimapSV.profileKeys = BasicMinimapSV.profileKeys or {}

        local CharacterProfile = UnitName("player") .. " - " .. GetRealmName()

        if BasicMinimapSV.profiles["FragUI"] then
            BasicMinimapSV.profileKeys[CharacterProfile] = "FragUI"
            FUI:PrettyPrint("|cFF8080FFBasicMinimap|r Profile Set to |cFF8080FFFragUI|r")
        else
            BasicMinimapSV.profiles["FragUI"] = BasicMinimapData
            BasicMinimapSV.profileKeys[CharacterProfile] = "FragUI"
            FUI:PrettyPrint("|cFF8080FFBasicMinimap|r Profile Imported Successfully!")
        end
    elseif addOnName == "ls_Toasts" then
        if not C_AddOns.IsAddOnLoaded("ls_Toasts") then FUI:PrettyPrint("LS: Toasts cannot be found. Please ensure it is |cFF40FF41installed|r/|cFF40FF40enabled|r.") return end
        local DecodedData = Compress:DecodeForPrint(importString)
        local DecompressedData = Compress:DecompressDeflate(DecodedData)
        local _, ToastData = Serialize:Deserialize(DecompressedData)
        LS_TOASTS_GLOBAL_CONFIG.profiles = LS_TOASTS_GLOBAL_CONFIG.profiles or {}
        LS_TOASTS_GLOBAL_CONFIG.profileKeys = LS_TOASTS_GLOBAL_CONFIG.profileKeys or {}

        local CharacterProfile = UnitName("player") .. " - " .. GetRealmName()

        if LS_TOASTS_GLOBAL_CONFIG.profiles["FragUI"] then
            LS_TOASTS_GLOBAL_CONFIG.profileKeys[CharacterProfile] = "FragUI"
            FUI:PrettyPrint("|cFF8080FFLS: Toasts|r Profile Set to |cFF8080FFFragUI|r")
        else
            LS_TOASTS_GLOBAL_CONFIG.profiles["FragUI"] = ToastData
            LS_TOASTS_GLOBAL_CONFIG.profileKeys[CharacterProfile] = "FragUI"
            FUI:PrettyPrint("|cFF8080FFLS: Toasts|r Profile Imported Successfully!")
        end
    end
    FUI:PromptReload()
end

function FUI:ExportProfile(addOnName)
    local addOnsToExport = {
        BasicMinimap = {
            source = BasicMinimapSV,
            profile = "FragUI",
            popup = "FRAGUI_EXPORT_BASICMINIMAP",
            label = "BasicMinimap"
        },
        ls_Toasts = {
            source = LS_TOASTS_GLOBAL_CONFIG,
            profile = "FragUI",
            popup = "FRAGUI_EXPORT_LSTOASTS",
            label = "LS: Toasts"
        }
    }

    local addOnConfig = addOnsToExport[addOnName]
    if not addOnConfig or not addOnConfig.source or not addOnConfig.source.profiles then return end

    local profileData = addOnConfig.source.profiles[addOnConfig.profile]
    if not profileData then return end

    local encoded = Compress:EncodeForPrint(Compress:CompressDeflate(Serialize:Serialize(profileData))
    )

    StaticPopupDialogs[addOnConfig.popup] = {
        text = addOnConfig.label .. " Data Exported. Copy the data below.",
        button1 = "OK",
        hasEditBox = true,
        maxLetters = 0,
        editBoxWidth = 400,
        OnShow = function(self)
            self.EditBox:SetText(encoded)
            self.EditBox:HighlightText()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    StaticPopup_Show(addOnConfig.popup)
end


function FUI:FetchCurrentProfileForAddOn(addOnName)
    if addOnName == "BasicMinimap" then
        if not C_AddOns.IsAddOnLoaded("BasicMinimap") then return "|cFFFF4040None|r. Please ensure it is |cFF40FF41installed|r/|cFF40FF40enabled|r." end
        return BasicMinimapSV.profileKeys[UnitName("player") .. " - " .. GetRealmName()]
    elseif addOnName == "ls_Toasts" then
        if not C_AddOns.IsAddOnLoaded("ls_Toasts") then return "|cFFFF4040None|r. Please ensure it is |cFF40FF41installed|r/|cFF40FF40enabled|r." end
        return LS_TOASTS_GLOBAL_CONFIG.profileKeys[UnitName("player") .. " - " .. GetRealmName()]
    end
end
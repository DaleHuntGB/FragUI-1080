local _, FUI = ...

local function GetFontConfig()
    local fontPath = STANDARD_TEXT_FONT
    local fontFlags = "OUTLINE"

    if FUI and FUI.db and FUI.db.global and FUI.db.global.Fonts then
        local dbFonts = FUI.db.global.Fonts
        if FUI.LSM and dbFonts.Font then
            local resolvedFont = FUI.LSM:Fetch("font", dbFonts.Font)
            if resolvedFont then fontPath = resolvedFont end
        end

        if dbFonts.FontFlag and dbFonts.FontFlag ~= "None" then
            fontFlags = dbFonts.FontFlag:gsub("%s+", "")
        end
    end

    return fontPath, fontFlags
end

local function BuildAddOnSnapshot()
    local addOnRows = {}
    local loadedCount = 0
    local enabledCount = 0
    local totalMemoryKb = 0
    UpdateAddOnMemoryUsage()

    for i = 1, C_AddOns.GetNumAddOns() do
        local addOnName, addOnTitle, _, isAddOnEnabled = C_AddOns.GetAddOnInfo(i)
        local displayName = addOnTitle and addOnTitle ~= "" and addOnTitle or addOnName or ("Unknown AddOn " .. i)
        local version = C_AddOns.GetAddOnMetadata(addOnName, "Version") or "Unknown"
        local isLoaded = C_AddOns.IsAddOnLoaded(addOnName)

        if isAddOnEnabled then
            enabledCount = enabledCount + 1
            if isLoaded then loadedCount = loadedCount + 1 end

            totalMemoryKb = totalMemoryKb + (GetAddOnMemoryUsage(i) or 0)

            local status = {}
            status[#status + 1] = "|cFF40FF40Enabled|r"
            status[#status + 1] = isLoaded and "|cFF40FF40Loaded|r" or "|cFFFFCC00Not Loaded|r"

            addOnRows[#addOnRows + 1] = {
                sortKey = string.lower(displayName),
                line = string.format("%s - %s (%s)", displayName, version, table.concat(status, ", "))
            }
        end
    end

    table.sort(addOnRows, function(a, b) return a.sortKey < b.sortKey end)

    local renderedRows = {}
    for index, row in ipairs(addOnRows) do
        renderedRows[#renderedRows + 1] = string.format("%03d. %s", index, row.line)
    end

    return table.concat(renderedRows, "\n"), {
        total = #addOnRows,
        loaded = loadedCount,
        enabled = enabledCount,
        memoryMb = totalMemoryKb / 1024
    }
end

local function BuildSystemSnapshot(addOnCounts)
    local wowVersion, wowBuild, wowBuildDate, interfaceVersion = GetBuildInfo()
    local localDateTime = date("%Y-%m-%d %H:%M:%S")
    local serverHour, serverMinute = GetGameTime()
    local _, instanceType, _, difficultyName = GetInstanceInfo()
    local homeLatency, worldLatency = select(3, GetNetStats())
    local fps = GetFramerate()
    local playerName, realmName = UnitName("player")
    local classDisplayName, classTag = UnitClass("player")
    local classColor = RAID_CLASS_COLORS[classTag]
    local classHex = classColor and CreateColor(classColor.r, classColor.g, classColor.b):GenerateHexColor() or "FFFFFFFF"
    local specName = "Unknown"
    local specIndex = GetSpecialization()

    if specIndex then
        specName = select(2, GetSpecializationInfo(specIndex)) or specName
    end

    local playerDisplay = playerName or "Unknown"
    if realmName and realmName ~= "" then
        playerDisplay = playerDisplay .. "-" .. realmName
    end

    local addonTitle = C_AddOns.GetAddOnMetadata("FragUI", "Title") or "FragUI"
    local addonVersion = C_AddOns.GetAddOnMetadata("FragUI", "Version") or "Unknown"
    local profileName = (FUI.db and FUI.db.GetCurrentProfile and FUI.db:GetCurrentProfile()) or "Unknown"
    local zoneName = GetRealZoneText() or "Unknown Zone"
    local mapName = C_Map.GetBestMapForUnit("player")
    local mapInfo = mapName and C_Map.GetMapInfo(mapName)
    local mapText = (mapInfo and mapInfo.name) or zoneName
    local uiScale = UIParent and UIParent:GetEffectiveScale() or 1
    local gxResolution = C_CVar.GetCVar("GxFullscreenResolution")
    local locale = GetLocale()

    return table.concat({
        string.format("|cFF8080FFCaptured|r: %s (Server %02d:%02d)", localDateTime, serverHour or 0, serverMinute or 0),
        string.format("|cFF8080FFAddon|r: %s - %s", addonTitle, addonVersion),
        string.format("|cFF8080FFPlayer|r: %s | |c%s%s|r | Spec: %s | Level: %d", playerDisplay, classHex, classDisplayName or "Unknown", specName, UnitLevel("player") or 0),
        string.format("|cFF8080FFZone|r: %s | Instance Type: %s | Difficulty: %s", mapText, instanceType or "none", difficultyName or "none"),
        string.format("|cFF8080FFClient|r: %s (%s, %s) | Interface: %s | Locale: %s", wowVersion or "Unknown", wowBuild or "Unknown", wowBuildDate or "Unknown", interfaceVersion or "Unknown", locale),
        string.format("|cFF8080FFPerformance|r: FPS: %.1f | Home: %dms | World: %dms | UI Scale: %.2f | Resolution: %s", fps or 0, homeLatency or 0, worldLatency or 0, uiScale, gxResolution),
        string.format("|cFF8080FFProfile|r: %s", profileName),
        string.format("|cFF8080FFAddOns|r: Total %d | Enabled %d | Loaded %d | Memory %.1f MB", addOnCounts.total, addOnCounts.enabled, addOnCounts.loaded, addOnCounts.memoryMb),
    }, "\n")
end

function FUI:RefreshDebugFrame()
    if not FUI.DebugFrame then return end

    local addOnText, counts = BuildAddOnSnapshot()
    FUI.DebugFrame.SystemInfoText:SetText(BuildSystemSnapshot(counts))
    FUI.DebugFrame.AddOnListText:SetText(addOnText)

    local width = math.max(1, FUI.DebugFrame.ScrollFrame:GetWidth() - 24)
    FUI.DebugFrame.ScrollChild:SetWidth(width)

    local height = FUI.DebugFrame.AddOnListText:GetStringHeight() + 16
    FUI.DebugFrame.ScrollChild:SetHeight(math.max(1, height))
end

local function CreateDebugFrame()
    local fontPath, fontFlags = GetFontConfig()
    local frame = CreateFrame("Frame", "FUI_DebugFrame", UIParent, "BackdropTemplate")
    frame:SetSize(512, 600)
    frame:SetPoint("CENTER")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("DIALOG")
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(20 / 255, 20 / 255, 20 / 255, 0.97)
    frame:SetBackdropBorderColor(0.15, 0.15, 0.15, 1)

    frame.Header = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    frame.Header:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    frame.Header:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    frame.Header:SetHeight(44)
    frame.Header:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    frame.Header:SetBackdropColor(14 / 255, 14 / 255, 14 / 255, 0.98)
    frame.Header:SetBackdropBorderColor(0.20, 0.20, 0.20, 1)

    frame.HeaderAccent = frame.Header:CreateTexture(nil, "ARTWORK")
    frame.HeaderAccent:SetColorTexture(128 / 255, 128 / 255, 1, 0.20)
    frame.HeaderAccent:SetPoint("BOTTOMLEFT", frame.Header, "BOTTOMLEFT", 0, 0)
    frame.HeaderAccent:SetPoint("BOTTOMRIGHT", frame.Header, "BOTTOMRIGHT", 0, 0)
    frame.HeaderAccent:SetHeight(1)

    frame.Title = frame.Header:CreateFontString(nil, "OVERLAY")
    frame.Title:SetPoint("LEFT", frame.Header, "LEFT", 12, 0)
    frame.Title:SetFont(fontPath, 16, fontFlags)
    local addonTitle = C_AddOns.GetAddOnMetadata("FragUI", "Title") or "|cFF8080FFFrag|rUI"
    frame.Title:SetText(FUI.LOGO .. addonTitle .. " Debug")
    frame.Title:SetJustifyH("LEFT")

    frame.CloseButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)

    frame.SystemInfoText = frame:CreateFontString(nil, "OVERLAY")
    frame.SystemInfoText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -58)
    frame.SystemInfoText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -16, -58)
    frame.SystemInfoText:SetFont(fontPath, 12, fontFlags)
    frame.SystemInfoText:SetJustifyH("LEFT")
    frame.SystemInfoText:SetJustifyV("TOP")

    frame.Separator = frame:CreateTexture(nil, "ARTWORK")
    frame.Separator:SetColorTexture(128 / 255, 128 / 255, 1, 0.20)
    frame.Separator:SetPoint("TOPLEFT", frame.SystemInfoText, "BOTTOMLEFT", 0, -10)
    frame.Separator:SetPoint("TOPRIGHT", frame.SystemInfoText, "BOTTOMRIGHT", 0, -10)
    frame.Separator:SetHeight(1)

    frame.AddOnHeading = frame:CreateFontString(nil, "OVERLAY")
    frame.AddOnHeading:SetPoint("TOPLEFT", frame.Separator, "BOTTOMLEFT", 0, -10)
    frame.AddOnHeading:SetFont(fontPath, 14, fontFlags)
    frame.AddOnHeading:SetJustifyH("LEFT")
    frame.AddOnHeading:SetText("|cFF8080FFAddOn List|r (Name - Version)")

    frame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    frame.ScrollFrame:SetPoint("TOPLEFT", frame.AddOnHeading, "BOTTOMLEFT", 0, -8)
    frame.ScrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -32, 16)

    frame.ScrollChild = CreateFrame("Frame", nil, frame.ScrollFrame)
    frame.ScrollChild:SetSize(1, 1)
    frame.ScrollFrame:SetScrollChild(frame.ScrollChild)

    frame.AddOnListText = frame.ScrollChild:CreateFontString(nil, "OVERLAY")
    frame.AddOnListText:SetPoint("TOPLEFT", frame.ScrollChild, "TOPLEFT", 0, 0)
    frame.AddOnListText:SetPoint("TOPRIGHT", frame.ScrollChild, "TOPRIGHT", -4, 0)
    frame.AddOnListText:SetFont(fontPath, 12, fontFlags)
    frame.AddOnListText:SetJustifyH("LEFT")
    frame.AddOnListText:SetJustifyV("TOP")

    frame:SetScript("OnShow", function() FUI:RefreshDebugFrame() end)
    frame:Hide()

    return frame
end

function FUI:GenerateDebugFrame()
    if not FUI.DebugFrame then
        FUI.DebugFrame = CreateDebugFrame()
        tinsert(UISpecialFrames, "FUI_DebugFrame")
    end

    FUI:RefreshDebugFrame()
    FUI.DebugFrame:Show()
    FUI.DebugFrame:Raise()
end

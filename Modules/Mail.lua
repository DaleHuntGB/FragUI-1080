local _, FUI = ...

local function FetchMail()
    if HasNewMail() and FUI.db.global.Mail.Enabled then
        FUI.MailFrame:Show()
    else
        FUI.MailFrame:Hide()
    end
end

local function FetchMailSenders()
    -- Blizzard Code: https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_Minimap/Mainline/Minimap.lua#L498C1-L503C4

    GameTooltip:SetOwner(FUI.MailFrame, "ANCHOR_NONE")
    GameTooltip:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -2, -1)

    local mailSenders = { GetLatestThreeSenders() }
    local headerText = #mailSenders >= 1 and HAVE_MAIL_FROM or HAVE_MAIL

    FormatUnreadMailTooltip(GameTooltip, headerText, mailSenders)
    GameTooltip:Show()
end

function FUI:SetupMailIcon()
    local MailDB = FUI.db.global.Mail

    local MailFrame = CreateFrame("Frame", "FUI_MailFrame", UIParent, "BackdropTemplate")
    MailFrame:SetSize(MailDB.Width, MailDB.Height)
    MailFrame:SetPoint(MailDB.Layout[1], Minimap, MailDB.Layout[2], MailDB.Layout[3], MailDB.Layout[4])

    FUI.MailFrame = MailFrame

    MailFrame.Texture = MailFrame:CreateTexture(nil, "BACKGROUND")
    MailFrame.Texture:SetAllPoints()
    MailFrame.Texture:SetTexture(FUI.MAIL_TEXTURES[MailDB.Texture])

    MailFrame.Texture:SetVertexColor(unpack(MailDB.Colour))

    MailFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    MailFrame:RegisterEvent("UPDATE_PENDING_MAIL")

    MailFrame:SetScript("OnEnter", function(self) FetchMailSenders() end)
    MailFrame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

    MailFrame:SetScript("OnEvent", FetchMail)
end

function FUI:UpdateMailIcon()
    local MailDB = FUI.db.global.Mail

    FUI.MailFrame:ClearAllPoints()
    FUI.MailFrame:SetSize(MailDB.Width, MailDB.Height)
    FUI.MailFrame:SetPoint(MailDB.Layout[1], Minimap, MailDB.Layout[2], MailDB.Layout[3], MailDB.Layout[4])
    FUI.MailFrame.Texture:SetTexture(FUI.MAIL_TEXTURES[MailDB.Texture])
    FUI.MailFrame.Texture:SetVertexColor(unpack(MailDB.Colour))

    if not MailDB.Enabled then FUI.MailFrame:Hide() else FetchMail() end
end
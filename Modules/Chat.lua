local _, FUI = ...

local ChatFrames = { ChatFrame1, ChatFrame2, ChatFrame3, ChatFrame4, ChatFrame5, ChatFrame6, ChatFrame7, ChatFrame8, ChatFrame9, ChatFrame10 }

local function StyleChatFrame()
    local ChatElements = {}

    for _, chatFrame in pairs(ChatFrames) do
        chatFrame:SetShadowColor(0, 0, 0, 0)
        local scrollBar = chatFrame.ScrollBar
        if scrollBar then
            tinsert(ChatElements, scrollBar)
            tinsert(ChatElements, scrollBar.Back)
            tinsert(ChatElements, scrollBar.Forward)
            tinsert(ChatElements, scrollBar.Track)
        end
    end

    for _, chatElement in pairs(ChatElements) do
        if chatElement then
            chatElement:SetAlpha(0)
            chatElement:Hide()
            chatElement:HookScript("OnShow", chatElement.Hide)
        end
    end
end

local function CreateChatBackdrop()
    local ChatDB = FUI.db.global.Chat
    local ChatFrameBackdrop = CreateFrame("Frame", "FragUI_ChatBackdrop", UIParent, "BackdropTemplate")
    ChatFrameBackdrop:SetSize(ChatDB.Width, ChatDB.Height)
    ChatFrameBackdrop:SetPoint(ChatDB.Layout[1], UIParent, ChatDB.Layout[2], ChatDB.Layout[3], ChatDB.Layout[4])
    ChatFrameBackdrop:SetBackdrop({
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    ChatFrameBackdrop:SetBackdropColor(ChatDB.Colour[1], ChatDB.Colour[2], ChatDB.Colour[3], ChatDB.Colour[4])
    ChatFrameBackdrop:SetBackdropBorderColor(0, 0, 0, 1)
    ChatFrameBackdrop:SetFrameStrata("LOW")
    FUI.ChatFrameBackdrop = ChatFrameBackdrop
    if not ChatDB.EnableBackdrop then FUI.ChatFrameBackdrop:SetAlpha(0) else FUI.ChatFrameBackdrop:SetAlpha(1) end
end

function FUI:UpdateChatBackdrop()
    local ChatDB = FUI.db.global.Chat
    FUI.ChatFrameBackdrop:ClearAllPoints()
    FUI.ChatFrameBackdrop:SetSize(ChatDB.Width, ChatDB.Height)
    FUI.ChatFrameBackdrop:SetPoint(ChatDB.Layout[1], UIParent, ChatDB.Layout[2], ChatDB.Layout[3], ChatDB.Layout[4])
    FUI.ChatFrameBackdrop:SetBackdrop({ edgeFile = "Interface\\Buttons\\WHITE8X8", bgFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1, })
    FUI.ChatFrameBackdrop:SetBackdropColor(ChatDB.Colour[1], ChatDB.Colour[2], ChatDB.Colour[3], ChatDB.Colour[4])
    FUI.ChatFrameBackdrop:SetBackdropBorderColor(0, 0, 0, 1)
    if not ChatDB.EnableBackdrop then FUI.ChatFrameBackdrop:SetAlpha(0) else FUI.ChatFrameBackdrop:SetAlpha(1) end
end

local function StyleEditBox()
    if not FUI.db.global.Chat.SkinChat then return end
    local EditBox = ChatFrame1EditBox
    if EditBox then
        ChatFrame1EditBoxHeader:SetShadowColor(0, 0, 0, 0)
        ChatFrame1EditBoxHeader:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
        EditBox:SetShadowColor(0, 0, 0, 0)
        EditBox:SetFont(FUI.Media.Font, 12, FUI.Media.FontFlag)
        EditBox:SetWidth(361)
        EditBox:SetHeight(28)
        -- EditBox:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)
    end
end

function FUI:SetupChat()
    StyleChatFrame()
    C_Timer.After(0.5, function() StyleEditBox() end)
    CreateChatBackdrop()
end
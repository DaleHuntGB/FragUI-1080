local _, FUI = ...

local function RemoveBlizzardTextures()
    if not FUI.db.global.Skinning.HideBlizzardTextures then return end
    local Frames = {
        ZoneTextFrame,
        SubZoneTextFrame,
        ObjectiveTrackerFrame.Header.Background,
        QuestObjectiveTracker.Header.Background,
        WorldQuestObjectiveTracker.Header.Background,
        ScenarioObjectiveTracker.Header.Background,
        MonthlyActivitiesObjectiveTracker.Header.Background,
        BonusObjectiveTracker.Header.Background,
        ProfessionsRecipeTracker.Header.Background,
        AchievementObjectiveTracker.Header.Background,
        CampaignQuestObjectiveTracker.Header.Background,
    }
    for _, Frame in pairs(Frames) do
        Frame:SetAlpha(0) Frame:Hide() Frame:SetScript("OnShow", function(Frame) Frame:SetAlpha(0) Frame:Hide() end)
    end
end

local function StyleBlizzardFonts()
    local ActionStatusDB = FUI.db.global.Skinning.ActionStatus
    local UIErrorsFrameDB = FUI.db.global.Skinning.UIErrorsFrame
    local ChatBubbleFontDB = FUI.db.global.Skinning.ChatBubbleFont
    local ObjectiveTrackerDB = FUI.db.global.Skinning.ObjectiveTracker

    ChatBubbleFont:SetFont(FUI.Media.Font, ChatBubbleFontDB.FontSize, FUI.Media.FontFlag)

    ObjectiveTrackerLineFont:SetFont(FUI.Media.Font, ObjectiveTrackerDB.Text.FontSize, FUI.Media.FontFlag)
    ObjectiveTrackerLineFont:SetShadowColor(0, 0, 0, 0)
    ObjectiveTrackerLineFont:SetShadowOffset(0, 0)

    ObjectiveTrackerHeaderFont:SetFont(FUI.Media.Font, ObjectiveTrackerDB.Header.FontSize, FUI.Media.FontFlag)
    ObjectiveTrackerHeaderFont:SetShadowColor(0, 0, 0, 0)
    ObjectiveTrackerHeaderFont:SetShadowOffset(0, 0)

    UIErrorsFrame:SetFont(FUI.Media.Font, UIErrorsFrameDB.FontSize, FUI.Media.FontFlag)
    UIErrorsFrame:ClearAllPoints()
    UIErrorsFrame:SetPoint(UIErrorsFrameDB.Layout[1], UIParent, UIErrorsFrameDB.Layout[2], UIErrorsFrameDB.Layout[3], UIErrorsFrameDB.Layout[4])
    UIErrorsFrame:SetShadowColor(0, 0, 0, 0)
    if not UIErrorsFrameDB.Enabled then UIErrorsFrame:SetAlpha(0) end

    ActionStatus.Text:SetFont(FUI.Media.Font, ActionStatusDB.FontSize, FUI.Media.FontFlag)
    ActionStatus.Text:ClearAllPoints()
    ActionStatus.Text:SetPoint(ActionStatusDB.Layout[1], UIParent, ActionStatusDB.Layout[2], ActionStatusDB.Layout[3], ActionStatusDB.Layout[4])
    ActionStatus.Text:SetShadowColor(0, 0, 0, 0)
end

function FUI:UpdateUIErrorsFrame()
    local UIErrorsFrameDB = FUI.db.global.Skinning.UIErrorsFrame
    UIErrorsFrame:SetFont(FUI.Media.Font, UIErrorsFrameDB.FontSize, FUI.Media.FontFlag)
    UIErrorsFrame:ClearAllPoints()
    UIErrorsFrame:SetPoint(UIErrorsFrameDB.Layout[1], UIParent, UIErrorsFrameDB.Layout[2], UIErrorsFrameDB.Layout[3], UIErrorsFrameDB.Layout[4])
    UIErrorsFrame:AddMessage("Template Text...")
    if not UIErrorsFrameDB.Enabled then UIErrorsFrame:SetAlpha(0) end
end

function FUI:UpdateActionStatus()
    local ActionStatusDB = FUI.db.global.Skinning.ActionStatus
    ActionStatus.Text:SetFont(FUI.Media.Font, ActionStatusDB.FontSize, FUI.Media.FontFlag)
    ActionStatus.Text:ClearAllPoints()
    ActionStatus.Text:SetPoint(ActionStatusDB.Layout[1], UIParent, ActionStatusDB.Layout[2], ActionStatusDB.Layout[3], ActionStatusDB.Layout[4])
    ActionStatus:DisplayMessage("Template Text...")
end

function FUI:UpdateChatBubbleFont()
    local ChatBubbleFontDB = FUI.db.global.Skinning.ChatBubbleFont
    ChatBubbleFont:SetFont(FUI.Media.Font, ChatBubbleFontDB.FontSize, FUI.Media.FontFlag)
end

function FUI:UpdateObjectiveTrackerFont()
    local ObjectiveTrackerDB = FUI.db.global.Skinning.ObjectiveTracker
    ObjectiveTrackerLineFont:SetFont(FUI.Media.Font, ObjectiveTrackerDB.Text.FontSize, FUI.Media.FontFlag)
    ObjectiveTrackerHeaderFont:SetFont(FUI.Media.Font, ObjectiveTrackerDB.Header.FontSize, FUI.Media.FontFlag)
end


function FUI:StyleBlizzard()
    RemoveBlizzardTextures()
    StyleBlizzardFonts()
end
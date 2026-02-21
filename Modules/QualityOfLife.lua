local _, FUI = ...

local function SkipAllCinematics()
    if not FUI.db.global.QualityOfLife.SkipCinematics then return end
    local SkipCinematicsFrame = CreateFrame("Frame")
    SkipCinematicsFrame:RegisterEvent("CINEMATIC_START")
    SkipCinematicsFrame:SetScript("OnEvent", function(self, event, ...) if event == "CINEMATIC_START" then CinematicFrame_CancelCinematic() end end)
    MovieFrame_PlayMovie = function(...)
        CinematicFinished(0)
        CinematicFinished(1)
        CinematicFinished(2)
        CinematicFinished(3)
    end
end

local function HideTalkingHeadFrame()
    if not FUI.db.global.QualityOfLife.HideTalkingHeadFrame then return end
    local TalkingHeadBlocker = CreateFrame("Frame", nil, UIParent)
    TalkingHeadBlocker:SetAllPoints(TalkingHeadFrame)
    TalkingHeadBlocker:SetFrameStrata("BACKGROUND")
    TalkingHeadBlocker:RegisterEvent("TALKINGHEAD_REQUESTED")
    TalkingHeadBlocker:HookScript("OnEvent", function(self, event, ...)
        if event == "TALKINGHEAD_REQUESTED" then
            TalkingHeadFrame:SetAlpha(0)
            TalkingHeadFrame:Hide()
        end
    end)
end

local function AutoSellRepair()
    local AutoSellRepairFrame = CreateFrame("Frame")
    AutoSellRepairFrame:RegisterEvent("MERCHANT_SHOW")

    local function SellJunk()
        local currentItem;
        for BagID = 0, 4 do
            for BagSlot = 1, C_Container.GetContainerNumSlots(BagID) do
                currentItem = C_Container.GetContainerItemLink(BagID, BagSlot)
                if currentItem then
                    local itemQuality = select(3, C_Item.GetItemInfo(currentItem))
                    local itemSellPrice = select(11, C_Item.GetItemInfo(currentItem))
                    if itemQuality == 0 and itemSellPrice ~= 0 then
                        C_Container.UseContainerItem(BagID, BagSlot)
                    end
                end
            end
        end
    end

    AutoSellRepairFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "MERCHANT_SHOW" or event == "PLAYER_INTERACTION_MANAGER_SHOW" then
            local sellGreys = FUI.db.global.QualityOfLife.AutoSellRepair.SellGreys
            local autoRepair = FUI.db.global.QualityOfLife.AutoSellRepair.AutoRepair
            local repairMethod = FUI.db.global.QualityOfLife.AutoSellRepair.RepairMethod

            if sellGreys then SellJunk() end
            if autoRepair and CanMerchantRepair() then
                local repairCost, canRepair = GetRepairAllCost()
                if canRepair and repairCost and repairCost > 0 then
                    local playerMoney = GetMoney()
                    local canGuild = CanGuildBankRepair() and GetGuildBankWithdrawMoney() >= repairCost
                    if repairMethod == "GUILD" then if canGuild then RepairAllItems(true) end return end
                    if repairMethod == "PERSONAL" then if playerMoney >= repairCost then RepairAllItems(false) end return end
                    if repairMethod == "BOTH" then if canGuild then RepairAllItems(true) elseif playerMoney >= repairCost then RepairAllItems(false) end return end
                end
            end
        end
    end)
end

local function SkipRoleCheck()
    local SkipRoleCheckFrame = CreateFrame("Frame")
    SkipRoleCheckFrame:RegisterEvent("PLAYER_LOGIN")

    SkipRoleCheckFrame:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" then
            LFGListApplicationDialog:HookScript("OnShow", function(popupWindow)
                local SkipRoleCheckDB = FUI.db.global.QualityOfLife.SkipRoleCheck
                if not SkipRoleCheckDB.Enabled then return end
                if IsControlKeyDown() then return end
                local acceptButton = popupWindow.SignUpButton
                if acceptButton and acceptButton:IsEnabled() then acceptButton:Click() end
            end)
        end
    end)
end

function FUI:SetupQualityOfLife()
    SkipAllCinematics()
    HideTalkingHeadFrame()
    AutoSellRepair()
    SkipRoleCheck()
end
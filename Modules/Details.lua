local _, FUI = ...

local function CreateDetailsBackdrop(frameName, detailsDB)
    local DetailsBackdropFrame = CreateFrame("Frame", frameName, UIParent, "BackdropTemplate")
    if FUI.db.global.Details.Layout == "HORIZONTAL" then
        DetailsBackdropFrame:SetSize(detailsDB.Width, detailsDB.HorizontalRows * 28.3)
    else
        DetailsBackdropFrame:SetSize(detailsDB.Width, detailsDB.VerticalRows * 28.3)
    end
    DetailsBackdropFrame:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", tile = true, tileSize = 1, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 } })
    DetailsBackdropFrame:SetBackdropColor(unpack(detailsDB.Colour))
    DetailsBackdropFrame:SetBackdropBorderColor(0, 0, 0, 1)
    DetailsBackdropFrame:SetFrameStrata("LOW")

    if detailsDB.Enabled then
        DetailsBackdropFrame:Show()
    else
        DetailsBackdropFrame:Hide()
    end

    return DetailsBackdropFrame
end

function FUI:SetupDetailsBackdrop()
    if not C_AddOns.IsAddOnLoaded("Details") then return end
    local DBF1 = _G["DetailsBaseFrame1"]
    local DWF1 = _G["Details_WindowFrame1"]
    local DBF2 = _G["DetailsBaseFrame2"]
    local DWF2 = _G["Details_WindowFrame2"]

    local TTAnchor = C_AddOns.IsAddOnLoaded("TipTac") and TipTac or nil

    if DBF1 and DWF1 then
        local DetailsFrameOne = CreateDetailsBackdrop("DetailsFrameOne", FUI.db.global.Details.One)
        DetailsFrameOne:SetPoint(FUI.db.global.Details.One.VerticalLayout[1], UIParent, FUI.db.global.Details.One.VerticalLayout[2], FUI.db.global.Details.One.VerticalLayout[3], FUI.db.global.Details.One.VerticalLayout[4])
        DBF1:ClearAllPoints()
        DWF1:ClearAllPoints()
        DBF1:SetSize(DetailsFrameOne:GetWidth() - 2, DetailsFrameOne:GetHeight())
        DWF1:SetSize(DetailsFrameOne:GetWidth() - 2, DetailsFrameOne:GetHeight())
        DBF1:SetPoint("BOTTOMRIGHT", DetailsFrameOne, "BOTTOMRIGHT", -1, -1)
        DWF1:SetPoint("BOTTOMRIGHT", DetailsFrameOne, "BOTTOMRIGHT", -1, -1)

        FUI.DetailsFrameOne = DetailsFrameOne

        if DBF1 and DWF1 then DetailsAttributeStringInstance1:SetShadowColor(0, 0, 0, 0) end
    end

    if DBF2 and DWF2 then
        local DetailsFrameTwo = CreateDetailsBackdrop("DetailsFrameTwo", FUI.db.global.Details.Two)
        if FUI.db.global.Details.Layout == "HORIZONTAL" then
            DetailsFrameTwo:SetPoint(FUI.db.global.Details.Two.HorizontalLayout[1], UIParent, FUI.db.global.Details.Two.HorizontalLayout[2], FUI.db.global.Details.Two.HorizontalLayout[3], FUI.db.global.Details.Two.HorizontalLayout[4])
        else
            DetailsFrameTwo:SetPoint(FUI.db.global.Details.Two.VerticalLayout[1], UIParent, FUI.db.global.Details.Two.VerticalLayout[2], FUI.db.global.Details.Two.VerticalLayout[3], FUI.db.global.Details.Two.VerticalLayout[4])
        end
        DBF2:ClearAllPoints()
        DWF2:ClearAllPoints()
        DBF2:SetSize(DetailsFrameTwo:GetWidth() - 2, DetailsFrameTwo:GetHeight())
        DWF2:SetSize(DetailsFrameTwo:GetWidth() - 2, DetailsFrameTwo:GetHeight())
        DBF2:SetPoint("BOTTOMRIGHT", DetailsFrameTwo, "BOTTOMRIGHT", -1, -1)
        DWF2:SetPoint("BOTTOMRIGHT", DetailsFrameTwo, "BOTTOMRIGHT", -1, -1)

        FUI.DetailsFrameTwo = DetailsFrameTwo

        if DBF2 and DWF2 then DetailsAttributeStringInstance2:SetShadowColor(0, 0, 0, 0) end
    end

    if FUI.db.global.Details.Layout == "HORIZONTAL" and TTAnchor then
        TTAnchor:ClearAllPoints()
        TTAnchor:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "TOPRIGHT", 0, 1)
    elseif TTAnchor then
        TTAnchor:ClearAllPoints()
        TTAnchor:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "BOTTOMLEFT", -1, 0)
    end
end

function FUI:UpdateDetailsBackdrop()
    local DBF1 = _G["DetailsBaseFrame1"]
    local DWF1 = _G["Details_WindowFrame1"]
    local DBF2 = _G["DetailsBaseFrame2"]
    local DWF2 = _G["Details_WindowFrame2"]

    local TTAnchor = C_AddOns.IsAddOnLoaded("TipTac") and TipTac or nil

    if DBF1 and DWF1 then
        FUI.DetailsFrameOne:ClearAllPoints()
        FUI.DetailsFrameOne:SetPoint(FUI.db.global.Details.One.VerticalLayout[1], UIParent, FUI.db.global.Details.One.VerticalLayout[2], FUI.db.global.Details.One.VerticalLayout[3], FUI.db.global.Details.One.VerticalLayout[4])
        if FUI.db.global.Details.Layout == "HORIZONTAL" then
            FUI.DetailsFrameOne:SetSize(FUI.db.global.Details.One.Width, FUI.db.global.Details.One.HorizontalRows * 28.3)
        else
            FUI.DetailsFrameOne:SetSize(FUI.db.global.Details.One.Width, FUI.db.global.Details.One.VerticalRows * 28.3)
        end
        FUI.DetailsFrameOne:SetBackdropColor(unpack(FUI.db.global.Details.One.Colour))
        DBF1:ClearAllPoints()
        DWF1:ClearAllPoints()
        DBF1:SetSize(FUI.DetailsFrameOne:GetWidth() - 2, FUI.DetailsFrameOne:GetHeight())
        DWF1:SetSize(FUI.DetailsFrameOne:GetWidth() - 2, FUI.DetailsFrameOne:GetHeight())
        DBF1:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "BOTTOMRIGHT", -1, -1)
        DWF1:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "BOTTOMRIGHT", -1, -1)
        if FUI.db.global.Details.One.Enabled then
            FUI.DetailsFrameOne:Show()
        else
            FUI.DetailsFrameOne:Hide()
        end
    end

    if DBF2 and DWF2 then
        FUI.DetailsFrameTwo:ClearAllPoints()
        if FUI.db.global.Details.Layout == "HORIZONTAL" then
            FUI.DetailsFrameTwo:SetPoint(FUI.db.global.Details.Two.HorizontalLayout[1], UIParent, FUI.db.global.Details.Two.HorizontalLayout[2], FUI.db.global.Details.Two.HorizontalLayout[3], FUI.db.global.Details.Two.HorizontalLayout[4])
        else
            FUI.DetailsFrameTwo:SetPoint(FUI.db.global.Details.Two.VerticalLayout[1], UIParent, FUI.db.global.Details.Two.VerticalLayout[2], FUI.db.global.Details.Two.VerticalLayout[3], FUI.db.global.Details.Two.VerticalLayout[4])
        end
        if FUI.db.global.Details.Layout == "HORIZONTAL" then
            FUI.DetailsFrameTwo:SetSize(FUI.db.global.Details.Two.Width, FUI.db.global.Details.Two.HorizontalRows * 28.3)
        else
            FUI.DetailsFrameTwo:SetSize(FUI.db.global.Details.Two.Width, FUI.db.global.Details.Two.VerticalRows * 28.3)
        end
        FUI.DetailsFrameTwo:SetBackdropColor(unpack(FUI.db.global.Details.Two.Colour))
        DBF2:ClearAllPoints()
        DWF2:ClearAllPoints()
        DBF2:SetSize(FUI.DetailsFrameTwo:GetWidth() - 2, FUI.DetailsFrameTwo:GetHeight())
        DWF2:SetSize(FUI.DetailsFrameTwo:GetWidth() - 2, FUI.DetailsFrameTwo:GetHeight())
        DBF2:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameTwo, "BOTTOMRIGHT", -1, -1)
        DWF2:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameTwo, "BOTTOMRIGHT", -1, -1)
        if FUI.db.global.Details.Two.Enabled then
            FUI.DetailsFrameTwo:Show()
        else
            FUI.DetailsFrameTwo:Hide()
        end
    end

    if FUI.db.global.Details.Layout == "HORIZONTAL" and TTAnchor then
        TTAnchor:ClearAllPoints()
        TTAnchor:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "TOPRIGHT", 0, 1)
    elseif TTAnchor then
        TTAnchor:ClearAllPoints()
        TTAnchor:SetPoint("BOTTOMRIGHT", FUI.DetailsFrameOne, "BOTTOMLEFT", -1, 0)
    end
end
local _, FUI = ...

function FUI:StyleBartender()
    if not C_AddOns.IsAddOnLoaded("Bartender4") then return end
    if not self.db.global.Skinning.SkinActionBars then return end
    C_Timer.After(0.1, function()
        for i = 1, 128 do
            local BT4Button = _G["BT4Button"..i]
            if BT4Button then
                if BT4Button.NormalTexture then BT4Button.NormalTexture:SetAlpha(0) end
                if BT4Button.IconMask then BT4Button.IconMask:Hide() end
                if BT4Button.InterruptDisplay then BT4Button.InterruptDisplay:SetAlpha(0) end
                if BT4Button.SpellCastAnimFrame then BT4Button.SpellCastAnimFrame:SetAlpha(0) end
                if BT4Button.SlotBackground then BT4Button.SlotBackground:SetTexture("Interface\\AddOns\\FragUI\\Media\\ActionBars\\Backdrop") BT4Button.SlotBackground:SetVertexColor(26/255, 26/255, 26/255, 1) end
            end

            local BT4PetButton = _G["BT4PetButton"..i]
            if BT4PetButton then
                if BT4PetButton.NormalTexture then BT4PetButton.NormalTexture:SetAlpha(0) end
                if BT4PetButton.IconMask then BT4PetButton.IconMask:Hide() end
                if BT4PetButton.InterruptDisplay then BT4PetButton.InterruptDisplay:SetAlpha(0) end
                if BT4PetButton.SpellCastAnimFrame then BT4PetButton.SpellCastAnimFrame:SetAlpha(0) end
                if BT4PetButton.SlotBackground then BT4PetButton.SlotBackground:SetTexture("Interface\\AddOns\\FragUI\\Media\\ActionBars\\Backdrop") BT4PetButton.SlotBackground:SetVertexColor(26/255, 26/255, 26/255, 1) end
            end

            local BT4StanceButton = _G["BT4StanceButton"..i]
            if BT4StanceButton then
                if BT4StanceButton.NormalTexture then BT4StanceButton.NormalTexture:SetAlpha(0) end
                if BT4StanceButton.IconMask then BT4StanceButton.IconMask:Hide() end
                if BT4StanceButton.InterruptDisplay then BT4StanceButton.InterruptDisplay:SetAlpha(0) end
                if BT4StanceButton.SpellCastAnimFrame then BT4StanceButton.SpellCastAnimFrame:SetAlpha(0) end
            end
        end
    end)
end
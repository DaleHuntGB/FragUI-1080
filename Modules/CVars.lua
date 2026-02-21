local _, FUI = ...

function FUI:SetupCVars()
    local CVars = {
        "floatingCombatTextCombatDamage_v2",
        "floatingCombatTextCombatHealing_v2",
        "ffxDeath",
        "ffxGlow",
        "ResampleAlwaysSharpen",
        "autoLootDefault",
        "nameplateShowOnlyNameForFriendlyPlayerUnits",
        "nameplateUseClassColorForFriendlyPlayerUnitNames",
        "SpellQueueWindow",
        "RAIDWaterDetail",
        "RAIDweatherDensity",
        "autoLootRate",
    }

    local values = FUI.db.global.CVars.Values

    for _, cvarName in ipairs(CVars) do
        if values[cvarName] == nil then
            values[cvarName] = C_CVar.GetCVar(cvarName) or "0"
        end

        if FUI.db.global.CVars.ApplyGlobally then
            C_CVar.SetCVar(cvarName, values[cvarName])
        end
    end
end

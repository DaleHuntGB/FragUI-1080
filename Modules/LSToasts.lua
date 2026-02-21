local _, FUI = ...

local function RegisterLSToastSkins()
	if not C_AddOns.IsAddOnLoaded("ls_Toasts") then return end
	local LST = _G.ls_Toasts
	if not LST or not LST[1] or not LST[1].RegisterSkin then return end

	LST[1]:RegisterSkin("fragui", {
		name = "|TInterface/AddOns/FragUI/Media/Textures/Logo_Small.png:12:12|t FragUI",
		template = "elv",
		text_bg = { hidden = true },
		leaves = { hidden = true },
		dragon = { hidden = true },
		icon_highlight = { hidden = true },
		bg = {
			default = {
				texture = {26/255, 26/255, 26/255, 1.0},
			},
		},
		glow = {
			texture = {1, 1, 1, 0.25},
			size = {226, 50},
		},
		shine = {
			tex_coords = {403 / 512, 465 / 512, 15 / 256, 61 / 256},
			size = {0.1, 0.1},
			point = { y = 0, },
		},
	})
end

local RegisterSkinsFrame = CreateFrame("Frame")
RegisterSkinsFrame:RegisterEvent("ADDON_LOADED")
RegisterSkinsFrame:SetScript("OnEvent", function(_, _, addOnName) if addOnName == "ls_Toasts" then RegisterLSToastSkins() end end)
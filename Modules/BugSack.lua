local _, FUI = ...

local PLAYER_CLASS = FUI.PLAYER_CLASS
local PLAYER_CLASS_COLOR = FUI.PLAYER_CLASS_COLOR
local PLAYER_CLASS_COLOR_HEX = FUI.PLAYER_CLASS_COLOR_HEX

function FUI:SetupBugSack()
	if not C_AddOns.IsAddOnLoaded("BugSack") then return end
	local ldb = LibStub("LibDataBroker-1.1", true)
	if not ldb then return end

	local bugSackLDB = ldb:GetDataObjectByName("BugSack")
	if not bugSackLDB then return end

	local bugAddon = _G["BugSack"]
	if not bugAddon or not bugAddon.UpdateDisplay or not bugAddon.GetErrors then return end

	if _G["FragUIBugsackButton"] then return end
	local FragUIBugsackButton = CreateFrame("Button", "FragUIBugsackButton", UIParent, "BackdropTemplate")
	FragUIBugsackButton:SetSize(16, 16)
	FragUIBugsackButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -1, -1)
	FragUIBugsackButton.Text = FragUIBugsackButton:CreateFontString(nil, "OVERLAY")
	FragUIBugsackButton.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, FUI.Media.FontFlag)
	FragUIBugsackButton.Text:SetPoint("CENTER", FragUIBugsackButton, "CENTER", 1, 0)
	FragUIBugsackButton.Text:SetTextColor(1, 1, 1)
	FragUIBugsackButton.Text:SetText("|cFF40FF400|r")
	FragUIBugsackButton:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		tile = false, tileSize = 0, edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	FragUIBugsackButton:SetBackdropColor(26/255, 26/255, 26/255, 1.0)
	FragUIBugsackButton:SetBackdropBorderColor(0, 0, 0, 1)

	FragUIBugsackButton:SetScript("OnClick", function(self, mouseButton)
		if bugSackLDB.OnClick then
			bugSackLDB.OnClick(self, mouseButton)
		end
	end)

	FragUIBugsackButton:SetScript("OnEnter", function(self)
		if bugSackLDB.OnTooltipShow then
			FragUIBugsackButton:SetBackdropBorderColor(PLAYER_CLASS_COLOR.r, PLAYER_CLASS_COLOR.g, PLAYER_CLASS_COLOR.b, 1.0)
			GameTooltip:SetOwner(self, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -2, -1)
			bugSackLDB.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)

	FragUIBugsackButton:SetScript("OnLeave", function()
		FragUIBugsackButton:SetBackdropBorderColor(0, 0, 0, 1)
		GameTooltip:Hide()
	end)

	hooksecurefunc(bugAddon, "UpdateDisplay", function()
		local count = #bugAddon:GetErrors(BugGrabber:GetSessionId())
		if count == 0 then
			FragUIBugsackButton.Text:SetText("|cFF40FF40" .. count .. "|r")
		else
			FragUIBugsackButton.Text:SetText("|cFFFF4040" .. count .. "|r")
		end
	end)
end
local AddonName = "DynamicPullTimer"
local DPT = LibStub("AceAddon-3.0"):NewAddon(AddonName);

local AceGUI = LibStub("AceGUI-3.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local minimapIcon = LibStub("LibDBIcon-1.0")
local defaults = {
    profile = {
        minimap = {},
        pulltime = 10
    }
}

function DPT:OnInitialize()
    DPT.db = LibStub("AceDB-3.0"):New("DynamicPullTimerDB", defaults, true)
end

function DPT:OnEnable()
	DPT.mainFrame = AceGUI:Create("Frame")
    DPT.mainFrame:SetTitle("DynamicPullTimer")
	DPT.mainFrame:SetLayout("List")
	DPT.mainFrame:SetWidth(150)
    DPT.mainFrame:SetHeight(150)
    DPT.mainFrame:Hide()

	DPT.timeSlider = AceGUI:Create("Slider")
	DPT.timeSlider:SetSliderValues(1, 30, 1)
    DPT.timeSlider:SetValue(DPT.db.profile.pulltime)
    DPT.timeSlider:SetFullWidth(true)
    DPT.timeSlider:SetCallback("OnMouseUp", function (_, _, value) DPT.db.profile.pulltime = value end)
	DPT.mainFrame:AddChild(DPT.timeSlider)

    DPT.ldbo = ldb:NewDataObject("DynamicPullTimer", {
        type = "launcher",
        icon = 413579,
        OnClick = function(clickedframe, button)
            if button == "LeftButton" then
                DPT:PullTimerStart(DPT.timeSlider:GetValue())
            elseif button == "RightButton" then
                DPT.mainFrame:Show()
            end
        end,
        OnTooltipShow = function(tooltip)
            if tooltip and tooltip.AddLine then
                tooltip:SetText(AddonName)
                tooltip:AddLine("Left Click to start pull timer")
                tooltip:AddLine("Right Click to configure pull timer")
                tooltip:Show()
            end
        end
    })

    minimapIcon:Register(AddonName, DPT.ldbo, DPT.db.profile.minimap)
end

function DPT:PullTimerStart(time)
    local chat = ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME);
    ChatEdit_ActivateChat(chat);
    chat:SetText("/pull " .. time);
    ChatEdit_OnEnterPressed(chat);
end
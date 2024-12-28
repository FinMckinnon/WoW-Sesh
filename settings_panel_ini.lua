-- Main Addon Frame
local setingsPanelFrame = CreateFrame("Frame", "setingsPanelFrame", UIParent, "BasicFrameTemplateWithInset")
setingsPanelFrame:SetSize(500, 350)
setingsPanelFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
setingsPanelFrame:SetResizable(true)
setingsPanelFrame:EnableMouse(true)
setingsPanelFrame:SetMovable(true)
setingsPanelFrame:RegisterForDrag("LeftButton")

-- Frame Title
setingsPanelFrame.TitleBg:SetHeight(30)
setingsPanelFrame.title = setingsPanelFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
setingsPanelFrame.title:SetPoint("TOPLEFT", setingsPanelFrame.TitleBg, "TOPLEFT", 5, -3)
setingsPanelFrame.title:SetText("MyAddon")

-- Enable dragging of the frame
setingsPanelFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
setingsPanelFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Play Sound on Show/Hide
setingsPanelFrame:SetScript("OnShow", function() PlaySound(808) end)
setingsPanelFrame:SetScript("OnHide", function() PlaySound(808) end)
setingsPanelFrame:Hide()

-- Register with UI Special Frames to allow Esc key closing
table.insert(UISpecialFrames, "SeshMainFrame")

-- Slash Command to toggle the main frame
SLASH_SESH1, SLASH_SESH2 = "/sesh", "/sh"
SlashCmdList["SESH"] = function()
    if setingsPanelFrame:IsShown() then
        setingsPanelFrame:Hide()
    else
        setingsPanelFrame:Show()
    end
end

-- Scrollable Settings Frame
local settingsFrame = CreateFrame("Frame", nil, setingsPanelFrame)
settingsFrame:SetSize(480, 270)
settingsFrame:SetPoint("TOPLEFT", 10, -40)

local scrollFrame = CreateFrame("ScrollFrame", nil, settingsFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 0, 0)
scrollFrame:SetSize(480, 240)

local scrollContent = CreateFrame("Frame", nil, scrollFrame)
scrollContent:SetSize(480, 30)
scrollFrame:SetScrollChild(scrollContent)

-- Resizing Constraints for the main frame
local minWidth, minHeight = 400, 300
local maxWidth, maxHeight = 800, 600

-- Resize Handle to allow users to resize the frame
local resizeHandle = CreateFrame("Button", nil, setingsPanelFrame)
resizeHandle:SetSize(16, 16)
resizeHandle:SetPoint("BOTTOMRIGHT", setingsPanelFrame, "BOTTOMRIGHT", -5, 5)
resizeHandle:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
resizeHandle:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
resizeHandle:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")

-- Handle mouse events for resizing
resizeHandle:SetScript("OnMouseDown", function()
    setingsPanelFrame:StartSizing("BOTTOMRIGHT")
end)

resizeHandle:SetScript("OnMouseUp", function()
    setingsPanelFrame:StopMovingOrSizing()
    local width, height = setingsPanelFrame:GetSize()
    setingsPanelFrame:SetWidth(math.max(minWidth, math.min(width, maxWidth)))
    setingsPanelFrame:SetHeight(math.max(minHeight, math.min(height, maxHeight)))
end)

-- Dynamically update the scroll frame size when the main frame is resized
setingsPanelFrame:SetScript("OnSizeChanged", function(self, width, height)
    scrollFrame:SetSize(width - 20, height - 80)
end)

setingsPanelFrameData = {
    scrollFrame = scrollFrame,
    scrollContent = scrollContent,
    UILineCount = 0, 
}
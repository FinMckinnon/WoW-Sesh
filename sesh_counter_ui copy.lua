-- Constants for base font sizes
local BASE_DURATION_FONT_SIZE = 16
local BASE_LIMIT_FONT_SIZE = 14


-- Create a new frame for the session counter
local counterFrame = CreateFrame("Frame", "SeshCounterFrame", UIParent, "BackdropTemplate")
counterFrame:SetSize(200, 50)  -- Default size
counterFrame:SetPoint("CENTER")
counterFrame:Hide()  -- Start hidden

-- Background setup
local bg = counterFrame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(counterFrame)
bg:SetColorTexture(0, 0, 0, 0.8)

-- Function to get show status
local function getShowSettingStatus(settingKey)
    if SESHDB.settingsKeys then
        return SESHDB.settingsKeys[settingKey]
    end
end

local function updatePanelText(textID, defaultText, getUpdatedText)
    local newText = getUpdatedText()
    if newText then
        textID:SetText(newText)
    else
        textID:SetText(defaultText)
    end
end

local function handleCounterPanelUpdate(
        durationText, 
        durationDefaultText, 
        getDurationRequirement, 
        getDurationUpdatedText, 
        limitText, 
        limitDefaultText, 
        getLimitRequirement, 
        getLimitUpdatedText,
        durationBg,
        limitBg
    )

    local durationRequirement = getDurationRequirement()
    local limitRequirement = getLimitRequirement()

    -- Update the duration text
    if durationRequirement then
        durationText:Show()
        durationBg:Show()
        updatePanelText(durationText, durationDefaultText, getDurationUpdatedText)
    else
        durationText:Hide()
        durationBg:Hide()
    end

    -- Update the limit text
    if limitRequirement then
        limitText:Show()
        limitBg:Show()
        updatePanelText(limitText, limitDefaultText, getLimitUpdatedText)
    else
        limitText:Hide()
        limitBg:Hide()
    end

    -- Dynamically adjust the counterFrame size based on the visibility of the text components
    local frameWidth, frameHeight = 200, 0  -- Default values

    if durationRequirement and limitRequirement then
        -- Both visible, calculate the combined height and set width accordingly
        frameWidth = math.max(durationText:GetWidth(), limitText:GetWidth()) + 20  -- Ensure enough width for both
        frameHeight = durationText:GetHeight() + limitText:GetHeight() + 15  -- Added space between duration and limit
        limitText:SetPoint("TOPLEFT", durationText, "BOTTOMLEFT", 0, -5)
        -- Adjust background sizes to fit the texts
        durationBg:SetSize(durationText:GetWidth() + 20, durationText:GetHeight() + 10)
        limitBg:SetSize(limitText:GetWidth() + 20, limitText:GetHeight() + 10)
        limitBg:SetPoint("CENTER", limitText, "CENTER")
    elseif durationRequirement then
        -- Only duration visible
        frameWidth = durationText:GetWidth() + 20
        frameHeight = durationText:GetHeight() + 10
        limitText:SetPoint("TOPLEFT", counterFrame, "TOPLEFT", 0, 0)  -- Reset position of limit
        -- Adjust background size to fit the text
        durationBg:SetSize(durationText:GetWidth() + 20, durationText:GetHeight() + 10)
        durationBg:SetPoint("CENTER", durationText, "CENTER")
    elseif limitRequirement then
        -- Only limit visible
        frameWidth = limitText:GetWidth() + 20
        frameHeight = limitText:GetHeight() + 10
        limitText:SetPoint("TOPLEFT", counterFrame, "TOPLEFT", 0, 0)
        -- Adjust background size to fit the text
        limitBg:SetSize(limitText:GetWidth() + 20, limitText:GetHeight() + 10)
        limitBg:SetPoint("CENTER", limitText, "CENTER")
    else
        -- No components visible, hide the frame
        counterFrame:Hide()
        return
    end

    -- Update the frame size based on the width and height calculated
    counterFrame:SetSize(frameWidth, frameHeight)

    -- Show the frame when at least one component is visible
    counterFrame:Show()
end

local function CreateSeshCounterPanel(parentFrame, durationConfig, getDurationRequirement, getDurationUpdatedText, limitConfig, getLimitRequirement, getLimitUpdatedText)
   -- Duration UI setup
   local durationText = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
   durationText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 10, -10)  -- Padding within the parent frame
   durationText:SetText(durationConfig.defaultText)
   durationText:SetJustifyH("CENTER")  -- Horizontal alignment (LEFT, CENTER, RIGHT)
   durationText:SetJustifyV("MIDDLE")  -- Vertical alignment (TOP, MIDDLE, BOTTOM)
   durationText:SetTextColor(1, 1, 0)  -- Set text color to yellow/gold

   -- Create a Frame for background around the duration text
   local durationBg = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")  -- Use BackdropTemplate
   durationBg:SetSize(durationText:GetWidth() + 20, durationText:GetHeight() + 10)  -- Adjust size to fit the text
   durationBg:SetPoint("CENTER", durationText, "CENTER")
   durationBg:SetBackdrop({
       edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",  -- Tooltip border for the edges
       edgeSize = 16,  -- Set the border thickness
       insets = { left = 3, right = 3, top = 3, bottom = 3 },  -- Optional padding for the background
   })
   durationBg:SetBackdropBorderColor(1, 1, 0)  -- Set the border to yellow/gold
   durationBg:SetBackdropColor(0, 0, 0, 0.7)  -- Dark transparent background

   -- Limit UI setup
   local limitText = parentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
   limitText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 10, -30)  -- Padding within the parent frame
   limitText:SetText(limitConfig.defaultText)
   limitText:SetJustifyH("CENTER")  -- Horizontal alignment (LEFT, CENTER, RIGHT)
   limitText:SetJustifyV("MIDDLE")  -- Vertical alignment (TOP, MIDDLE, BOTTOM)
   limitText:SetTextColor(1, 1, 0)  -- Set text color to yellow/gold

   -- Create a Frame for background around the limit text
   local limitBg = CreateFrame("Frame", nil, parentFrame, "BackdropTemplate")  -- Use BackdropTemplate
   limitBg:SetSize(limitText:GetWidth() + 20, limitText:GetHeight() + 10)  -- Adjust size to fit the text
   limitBg:SetPoint("CENTER", limitText, "CENTER")
   limitBg:SetBackdrop({
       edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",  -- Tooltip border for the edges
       edgeSize = 16,  -- Set the border thickness
       insets = { left = 3, right = 3, top = 3, bottom = 3 },  -- Optional padding for the background
   })
   limitBg:SetBackdropBorderColor(1, 1, 0)  -- Set the border to yellow/gold
   limitBg:SetBackdropColor(0, 0, 0, 0.7)  -- Dark transparent background

   -- Return the created UI elements so they are accessible elsewhere
   return durationText, limitText, durationBg, limitBg
end

-- Enable dragging and scaling
local function enableFrameDraggingAndScaling(frame)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

-- Function to adjust the size of text and background elements based on scale
local function adjustTextAndBgSizes(scaleFactor)
    local newDurationFontSize = BASE_DURATION_FONT_SIZE * scaleFactor
    local newLimitFontSize = BASE_LIMIT_FONT_SIZE * scaleFactor

    -- Scale duration text and limit text
    durationText:SetFont("Fonts\\FRIZQT__.TTF", newDurationFontSize)
    limitText:SetFont("Fonts\\FRIZQT__.TTF", newLimitFontSize)

    -- Adjust background sizes
    durationBg:SetSize(durationText:GetWidth() + 20, durationText:GetHeight() + 10)
    limitBg:SetSize(limitText:GetWidth() + 20, limitText:GetHeight() + 10)

    -- Update the frame size
    local frameWidth = math.max(durationText:GetWidth(), limitText:GetWidth()) + 20
    local frameHeight = durationText:GetHeight() + limitText:GetHeight() + 15
    counterFrame:SetSize(frameWidth, frameHeight)
end

-- Function to initialize the session counter UI
local function InitializeCounterUI()

    local durationConfig = {
        labelText = "Session Duration",
        defaultText = "No Active Session."
       }
    
       local limitConfig = {
        labelText = "Session Time Limit",
        defaultText = "No Limit Set."
       }

    -- Create the panel and get the background frames
    durationText, limitText, durationBg, limitBg = CreateSeshCounterPanel(
        counterFrame, 
        durationConfig,
        function() return getShowSettingStatus("showSessionTimeCheckbox") end, 
        getSessionDurationString, 
        limitConfig,
        function() return getShowSettingStatus("showSessionLimitCheckbox") end,
        getTimeLimitString
    )

    -- Enable frame dragging and scaling
    enableFrameDraggingAndScaling(counterFrame)

    -- Initialize with a default scale factor (1 = original size)
    local initialScale = 1
    adjustTextAndBgSizes(initialScale)

    -- Show the frame even if there’s no visible content
    counterFrame:Show()

    -- Set up a repeating timer to update the UI periodically
    AceSeshTimer:ScheduleRepeatingTimer(function()
        handleCounterPanelUpdate(
            durationText, 
            durationConfig.defaultText, 
            function() return getShowSettingStatus("showSessionTimeCheckbox") end, 
            getSessionDurationString, 
            limitText, 
            limitConfig.defaultText, 
            function() return getShowSettingStatus("showSessionLimitCheckbox") end, 
            getTimeLimitString,
            durationBg,
            limitBg
        )
    end, 0.5)
end

-- Listen for ADDON_LOADED to initialize the session counter UI
local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("ADDON_LOADED")
addonFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MyPlaytimeTracker" then
        InitializeCounterUI()
    end
end)


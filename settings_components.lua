-- Constants for spacing
local PADDING = { top = 10, left = 10, bottom = 10, right = 10 }
local SPACING = { checkbox = 10, input = 20, button = 10, header = 12 }

-- Utility function for vertical layout
local function AddToVerticalLayout(parent, element, spacing)
    if element == parent.lastElement then
        return 
    end
    
    if not parent.lastElement then
        element:SetPoint("TOPLEFT", parent, "TOPLEFT", PADDING.left, -PADDING.top)
    else
        element:SetPoint("TOPLEFT", parent.lastElement, "BOTTOMLEFT", 0, -spacing)
    end

    parent.lastElement = element
end


-- Updates the scrollable content height dynamically
local function UpdateContentHeight(setingsPanelFrameData, elementHeight)
    if not setingsPanelFrameData.totalHeight then setingsPanelFrameData.totalHeight = 0 end
    setingsPanelFrameData.totalHeight = setingsPanelFrameData.totalHeight + elementHeight + SPACING.header
    setingsPanelFrameData.scrollContent:SetHeight(setingsPanelFrameData.totalHeight)
end

local function CreateCheckbox(text, key, tooltip, defaultValue, setingsPanelFrameData)
    local checkbox = CreateFrame("CheckButton", nil, setingsPanelFrameData.scrollContent, "UICheckButtonTemplate")
    checkbox.Text:SetText(text)

    -- Initialize saved setting
    SESHDB.settingsKeys[key] = SESHDB.settingsKeys[key] or defaultValue
    checkbox:SetChecked(SESHDB.settingsKeys[key])

    -- Tooltip handling
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    checkbox:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Save setting on click
    checkbox:SetScript("OnClick", function(self)
        SESHDB.settingsKeys[key] = self:GetChecked()
    end)

    -- Ensure checkbox visibility persists
    checkbox:SetScript("OnShow", function(self)
        self:SetChecked(SESHDB.settingsKeys[key])
    end)

    -- Add to layout and update height
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, checkbox, SPACING.checkbox)
    UpdateContentHeight(setingsPanelFrameData, checkbox:GetHeight())

    return checkbox
end

-- Creates a single-line input field
local function CreateTextInput(labelText, key, tooltip, defaultValue, setingsPanelFrameData)
    local container = CreateFrame("Frame", nil, setingsPanelFrameData.scrollContent)
    container:SetSize(200, 50)

    local label = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    label:SetText(labelText)

    local input = CreateFrame("EditBox", nil, container, "InputBoxTemplate")
    input:SetSize(200, 30)
    input:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
    input:SetAutoFocus(false)
    input:SetText(defaultValue)

    SESHDB.settingsKeys[key] = SESHDB.settingsKeys[key] or defaultValue

    input:SetScript("OnTextChanged", function(self)
        SESHDB.settingsKeys[key] = self:GetText()
    end)

    input:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
    end)
    input:SetScript("OnLeave", GameTooltip.Hide)

    -- Add to layout and update height
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, container, SPACING.input)
    UpdateContentHeight(setingsPanelFrameData, container:GetHeight())

    return input
end

local function CreateButton(text, onClick, setingsPanelFrameData)
    local button = CreateFrame("Button", nil, setingsPanelFrameData.scrollContent, "UIPanelButtonTemplate")
    button:SetSize(70, 30)
    button:SetText(text)

    -- Ensure onClick is a valid function
    if type(onClick) == "function" then
        button:SetScript("OnClick", function()
            onClick()
        end)
    else
        print("Creating button with text:", text)
        print("Error: onClick is not a function.")
    end
    
    -- Tooltip handling
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Click to perform action", nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Add to layout and update height
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, button, SPACING.button)
    UpdateContentHeight(setingsPanelFrameData, button:GetHeight())

    return button
end


-- Creates a section header with a title and separator
local function CreateSectionHeader(title, setingsPanelFrameData, headingsize)
    -- Set default heading size to h1 if not provided
    headingsize = headingsize or "h1"  -- Default to h1 if no size is specified
    
    -- Create the header frame
    local header = CreateFrame("Frame", nil, setingsPanelFrameData.scrollContent)
    header:SetSize(setingsPanelFrameData.scrollContent:GetWidth(), 30)

    -- Create the label (font size will depend on headingsize)
    local label = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge") -- default to large size
    if headingsize == "h1" then
        label:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")  -- Largest
    elseif headingsize == "h2" then
        label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")  -- Medium
    elseif headingsize == "h3" then
        label:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")  -- Smallest
    else
        label:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")  -- Default to h1 if invalid size
    end
    label:SetPoint("TOPLEFT", header, "TOPLEFT", 0, 0)
    label:SetText(title)

    -- Create the separator line with transparency adjustments
    local line
    if headingsize ~= "h3" then  -- No line for h3
        line = header:CreateTexture(nil, "BACKGROUND")
        line:SetHeight(1)
        
        if headingsize == "h2" then
            line:SetColorTexture(0.8, 0.8, 0.8, 0.5)  -- Slightly transparent for h2
        else
            line:SetColorTexture(0.8, 0.8, 0.8, 1)    -- Fully opaque for h1
        end

        line:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
        line:SetPoint("TOPRIGHT", header, "TOPRIGHT", 0, -5)
    end

    -- Add to layout and update height
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, header, SPACING.header)
    UpdateContentHeight(setingsPanelFrameData, header:GetHeight())

    return header
end

local function CreateUpdatingDisplayText(labelText, setingsPanelFrameData, getRequirement, defaultText, updateFrequency, getUpdatedText, skipAdjust)
    -- Create a container for the label and display text
    local container = CreateFrame("Frame", nil, setingsPanelFrameData.scrollContent)
    container:SetSize(200, 50) -- Adjust size as needed

    -- Create the label for the display text
    local label = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    label:SetText(labelText)

    -- Create the display-only text field
    local displayText = container:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    displayText:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -5)
    displayText:SetText(defaultText)

    -- Add to layout and update height
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, container, SPACING.input)
    UpdateContentHeight(setingsPanelFrameData, container:GetHeight())

    updateCounterTimer = AceSeshTimer:ScheduleRepeatingTimer(function()
        local requirement = getRequirement()
        if requirement then
            local newText = getUpdatedText()
            if newText then
                displayText:SetText(newText)
            end
        else 
            displayText:SetText(defaultText)
        end
    end, updateFrequency) 

    -- Return label and displayText
    return label, displayText
end

local function MultiInputWithBtn(settingText, settingKey, settingTooltip, inputsConfig, buttonConfig, setingsPanelFrameData, handleOnClick, skipAdjust)
    local inputs = {}
    local errorMessage

    -- Create a container to hold all inputs, labels, description, and the button
    local container = CreateFrame("Frame", nil, setingsPanelFrameData.scrollContent)
    local containerWidth = (50 + 10) * #inputsConfig + 100  -- Adjust size to fit inputs and the button (50px for inputs, 10px for spacing)
    container:SetSize(containerWidth, 100)  -- Adjust height to include description
    AddToVerticalLayout(setingsPanelFrameData.scrollContent, container, SPACING.input)

    -- Add a description label above the input labels
    local descriptionLabel = container:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    descriptionLabel:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    descriptionLabel:SetText(settingText)

    -- Create inputs based on configuration
    for i, inputConfig in ipairs(inputsConfig) do
        local input = CreateFrame("EditBox", "SeshInputID_" .. inputConfig.key, container, "InputBoxTemplate")
        input:SetSize(50, 30)
        input:SetPoint("LEFT", container, "LEFT", (i - 1) * (50 + 10) + 5, 0)  -- Added +20 to shift inputs to the right
        input:SetAutoFocus(false)
        input:SetText("0")

        -- Tooltip handling
        input:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(inputConfig.text .. ": " .. settingTooltip, nil, nil, nil, nil, true)
        end)
        input:SetScript("OnLeave", function() GameTooltip:Hide() end)

        -- Label for the input field
        local label = container:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("BOTTOMLEFT", input, "TOPLEFT", -3 + 2, -5)
        label:SetText(inputConfig.text)

        table.insert(inputs, input)
    end

    -- Create the button, placed below the inputs
    local button = CreateButton(buttonConfig.text, function()
        local inputValues, concatenatedString = handleMultiInputBtnClick(inputs, inputsConfig, errorMessage)
        if inputValues then
            handleOnClick(concatenatedString)

            -- Reset inputs to "0" on valid input
            for _, input in ipairs(inputs) do
                input:SetText("0")
            end
        end
    end, setingsPanelFrameData)

    -- Custom button size: width and height as per buttonConfig
    button:SetSize(70, 30)

    -- Position the button below the last input
    button:SetPoint("TOPLEFT", container, "BOTTOMLEFT", -5, 10)

    -- Error message setup
    errorMessage = setingsPanelFrameData.scrollContent:CreateFontString(nil, "OVERLAY", "GameFontRed")
    errorMessage:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, -10)
    errorMessage:SetText("")

    -- Initially hidden
    errorMessage:Hide()

    -- Update content height after all elements are added
    UpdateContentHeight(setingsPanelFrameData, container:GetHeight())
    UpdateContentHeight(setingsPanelFrameData, button:GetHeight())

    return inputs, errorMessage
end

-- Expose the components
_G["CreateSectionHeader"] = CreateSectionHeader
_G["CreateButton"] = CreateButton
_G["CreateTextInput"] = CreateTextInput
_G["CreateCheckbox"] = CreateCheckbox
_G["CreateUpdatingDisplayText"] = CreateUpdatingDisplayText
_G["MultiInputWithBtn"] = MultiInputWithBtn

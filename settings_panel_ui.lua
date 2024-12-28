local function getFormattedSessionDuration()
    if Sesh.sessionDuration then
        return formatTime(Sesh.sessionDuration)
    end
end

local function getFormattedTimeLimit()
    if Sesh.timeLimit then
        return formatTime(Sesh.timeLimit)
    end
end

local function getSeshTimeLimit()
    return Sesh.timeLimit
end

local function getSeshStart()
    return Sesh.sessionStart
end

-- Initialize Settings on PLAYER_LOGIN
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    -- Initialize default settings
    SESHDB.settingsKeys.enableShowSaveMessages = SESHDB.settingsKeys.enableShowSaveMessages or false

    -- Create UI elements
    CreateSectionHeader("Current Sesh", setingsPanelFrameData)

    -- Create the session duration display
    CreateUpdatingDisplayText(
        "Session Duration:", 
        setingsPanelFrameData, 
        getSeshStart, 
        "No Current Session.",
        0.5,
        getFormattedSessionDuration
    )

    -- Create the session limit display
    CreateUpdatingDisplayText(
        "Session Limit:", 
        setingsPanelFrameData, 
        getSeshTimeLimit,
        "No Time Limit.",
        1,
        getFormattedTimeLimit
    )

    CreateButton("Start", handleStartSession, setingsPanelFrameData)

    CreateButton("Stop", handleStopSession, setingsPanelFrameData)

    CreateButton("Pause", handlePauseSession, setingsPanelFrameData)

    CreateButton("Resume", handleResumeSession, setingsPanelFrameData)

    for _, inputGroup in ipairs(settingsData.setSessionLimit) do
        MultiInputWithBtn(
            inputGroup.settingText,
            inputGroup.settingKey,
            inputGroup.settingTooltip,
            inputGroup.inputs,
            inputGroup.button,
            setingsPanelFrameData,
            handleSetSessionLimit
        )
    end

    CreateSectionHeader("Sesh Settings", setingsPanelFrameData)

    for _, checkbox in pairs(settingsData.showSessionTimeCheckbox) do
        CreateCheckbox(checkbox.settingText, checkbox.settingKey, checkbox.settingTooltip, checkbox.defaultValue, setingsPanelFrameData)
    end

    for _, checkbox in pairs(settingsData.showSessionLimitCheckbox) do
        CreateCheckbox(checkbox.settingText, checkbox.settingKey, checkbox.settingTooltip, checkbox.defaultValue, setingsPanelFrameData)
    end

    for _, inputGroup in ipairs(settingsData.setWarningIntervalInput) do
        MultiInputWithBtn(
            inputGroup.settingText,
            inputGroup.settingKey,
            inputGroup.settingTooltip,
            inputGroup.inputs,
            inputGroup.button,
            setingsPanelFrameData,
            handleSetWarningInterval
        )
    end
end)

-- Complete

local function handleSetSessionLimit(newLimit)
    setTimeLimitFromString(newLimit)
    if not Sesh.sessionStart then
        startSession()
    end
end

local function handleSetWarningInterval(newIntervalString)
    setWarningInterval(newIntervalString)
end

local function handleStartSession()
    startSession()
end

local function handleStopSession()
    stopSession()
end

local function handlePauseSession()
    pauseSession()
end

local function handleResumeSession()
    resumeSession()
end

-- Todo

-- Handle integer input validation
local function handleIntInput(input, isInt)
    local currentValue = getInputText(input)
    if currentValue == nil or currentValue == "" then
        input:SetText("0")
        currentValue = "0"
    end
    if isInt and not checkIfInt(currentValue) then
        return false, nil
    else
        return true, currentValue
    end
end

local function handleMultiInputBtnClick(inputs, inputsConfig, errorMessage)
    local allValid = true
    local inputValues = {}
    local concatenatedString = "" -- To store the final formatted string

    for index, input in ipairs(inputs) do
        if inputsConfig[index].isInt then
            local isValid, currentValue = handleIntInput(input, inputsConfig[index].isInt)
            if not isValid then
                allValid = false
                break
            else
                table.insert(inputValues, currentValue)
                -- Append the current value with its unit to the concatenated string
                concatenatedString = concatenatedString .. currentValue .. (inputsConfig[index].unit or "") -- Add unit if present
            end
        end
    end

    if not allValid then
        errorMessage:SetText("Invalid input detected! Please use the correct syntax.")
        errorMessage:Show()
        return nil
    else
        errorMessage:Hide()
        return inputValues, concatenatedString 
    end
end

-- Export
_G["handleMultiInputBtnClick"] = handleMultiInputBtnClick
_G["handleSetSessionLimit"] = handleSetSessionLimit
_G["handleSetWarningInterval"] = handleSetWarningInterval
_G["handleStartSession"] = handleStartSession
_G["handleStopSession"] = handleStopSession
_G["handlePauseSession"] = handlePauseSession
_G["handleResumeSession"] = handleResumeSession
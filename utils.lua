-- Function to format seconds into a nice format (days, hours, minutes, seconds)
local function formatTime(seconds)
    local days = math.floor(seconds / (24 * 3600))
    local hours = math.floor((seconds % (24 * 3600)) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local sec = seconds % 60
    local timeStr = ""

    if days > 0 then
        timeStr = timeStr .. days .. "d "
    end
    if hours > 0 or days > 0 then
        timeStr = timeStr .. hours .. "h "
    end
    if minutes > 0 or hours > 0 or days > 0 then
        timeStr = timeStr .. minutes .. "m "
    end
    timeStr = timeStr .. sec .. "s" -- Always display seconds
    return timeStr
end

-- Function to convert time string (e.g., "2d1h30m15s") into seconds
local function convertTimeToSeconds(timeStr)
    local days, hours, minutes, seconds = 0, 0, 0, 0

    -- Match and extract time units (days, hours, minutes, seconds)
    for num, unit in timeStr:gmatch("(%d+)([a-zA-Z]+)") do
        num = tonumber(num)
        if unit == "d" then
            days = num
        elseif unit == "h" then
            hours = num
        elseif unit == "m" then
            minutes = num
        elseif unit == "s" then
            seconds = num
        end
    end

    -- If no valid time units were found, return false
    if days == 0 and hours == 0 and minutes == 0 and seconds == 0 then
        return 
    end

    -- Convert everything into seconds
    local timeInSeconds = days * 24 * 3600 + hours * 3600 + minutes * 60 + seconds
    return timeInSeconds
end

local function getSessionDurationString()
    if Sesh.sessionDuration then
        return formatTime(Sesh.sessionDuration)
    end
end

local function getTimeLimitString()
    if Sesh.timeLimit then
        return formatTime(Sesh.timeLimit)
    end
end

local function saveSeshData()
    SeshSavedData.totalPlaytime = Sesh.totalPlaytime
    SeshSavedData.sessionStart = Sesh.sessionStart
    SeshSavedData.paused = Sesh.paused
    SeshSavedData.pauseTime = Sesh.pauseTime
    SeshSavedData.timeLimit = Sesh.timeLimit
    SeshSavedData.isLoggedOut = Sesh.isLoggedOut
    SeshSavedData.logoutTime = Sesh.logoutTime
    SeshSavedData.sessionDuration = Sesh.sessionDuration
end

local function loadSeshData()
    Sesh.totalPlaytime = SeshSavedData.totalPlaytime or 0
    Sesh.sessionStart = SeshSavedData.sessionStart
    Sesh.sessionDuration = SeshSavedData.sessionDuration
    Sesh.paused = SeshSavedData.paused
    Sesh.pauseTime = SeshSavedData.pauseTime
    Sesh.timeLimit = SeshSavedData.timeLimit
    Sesh.isLoggedOut = SeshSavedData.isLoggedOut
    Sesh.logoutTime = SeshSavedData.logoutTime
end

local function initaliseSeshData()
    if GLOBAL_RESET then
        print("Resetting Sesh Settings...")
        SeshSettings = nil 
        print("Resetting Sesh Database...")
        SESHDB = nil
        print("Sesh Reset.")
    end

    if not SeshSettings then 
        print("SeshSettings not found, initialising...")
        SeshSettings = {
            showSaveMessages = false, 
            warningInterval = 60,
        } 
    end

    if not SESHDB or not SESHDB.settingsKeys then 
        print("SESHDB not found, initialising...")
        SESHDB = {settingsKeys = {
            showSessionTimeCheckbox = false, 
            showSessionLimitCheckbox = false
        }
    } 
    end

    if not SeshSavedData then
        SeshSavedData = {}
    end

    -- Initialize non-persistent Sesh table
    Sesh = {
        sessionStart = nil,
        totalPlaytime = 0,
        paused = false,
        pauseTime = nil,
        timeLimitExceeded = false,  -- Flag for time limit check
        timeLimit = nil,
        lastWarningTime = nil,  -- Store the last warning time
        isLoggedOut = false,  -- New flag for logout state
        logoutTime = nil,  -- Store the logout time
        afk = false,  -- New flag for AFK state
        afkTime = nil  -- Store the time when the player went AFK
    }
end

local function checkIfInt(value)
    if value then
        return tonumber(value) ~= nil and math.floor(tonumber(value)) == tonumber(value)
    end
end

local function getInputText(input)
    return input:GetText():match("^%s*(.-)%s*$")
end

local function getStringSessionTime()
    if Sesh.sessionDuration then
        return formatTime(Sesh.sessionDuration)
    end
end

local function getWarningInterval()
    if SeshSettings.warningInterval then
        return SeshSettings.warningInterval
    end
end

-- Expose the function to the global namespace
_G["formatTime"] = formatTime
_G["convertTimeToSeconds"] = convertTimeToSeconds
_G["getSessionPlayTime"] = getSessionPlayTime
_G["loadSeshData"] = loadSeshData
_G["initaliseSeshData"] = initaliseSeshData
_G["checkIfInt"] = checkIfInt
_G["getInputText"] = getInputText
_G["getStringSessionTime"] = getStringSessionTime
_G["saveSeshData"] = saveSeshData
_G["getSessionDurationString"] = getSessionDurationString
_G["getTimeLimitString"] = getTimeLimitString
_G["getWarningInterval"] = getWarningInterval

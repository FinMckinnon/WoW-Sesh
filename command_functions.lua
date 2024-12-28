-- Start AceTimer
local function startAceSeshTimer()
    if not sessionTimer then
        sessionTimer = AceSeshTimer:ScheduleRepeatingTimer(AceSeshTimerHandler, 1) -- Fires every second
    end
end

-- Stop AceTimer
local function stopAceSeshTimer()
    if sessionTimer then
        AceSeshTimer:CancelTimer(sessionTimer)
        sessionTimer = nil
    end
end

local function setTimeLimitFromString(timeLimitString)
    local timeLimitInSeconds = convertTimeToSeconds(timeLimitString)
    if timeLimitInSeconds then
        print("Sesh limit set to "..timeLimitString)
        Sesh.timeLimit = timeLimitInSeconds  
    end
end

--
local function startSession(args)
    print("Starting session")
    if Sesh.sessionStart then
        print("Session already in progress! Current session is ".. getSessionDurationString())
        return
    end

    if args then
        setTimeLimitFromString(args) -- Sets Sesh.timeLimit
    end

    Sesh.sessionStart = time() 
    Sesh.sessionDuration = 0
    Sesh.paused = false
    Sesh.pauseTime = nil
    Sesh.timeLimitExceeded = false  
    print("Session Started.")
    if Sesh.timeLimit then
        print("Time limit set to: " .. getTimeLimitString())
    else
        print("! NO TIME LIMIT SET !")
    end

    startAceSeshTimer()
end

local function toggleSaveMessages()
    if SeshSettings.showSaveMessages then
        SeshSettings.showSaveMessages = false
        print("Save messages are now OFF.")
    else
        SeshSettings.showSaveMessages = true
        print("Save messages are now ON.")
    end
end

local function setWarningInterval(args)
    local intervalInSeconds = convertTimeToSeconds(args)
    if intervalInSeconds then
        SeshSettings.warningInterval = intervalInSeconds
        print("Repeating warning interval set to: " .. args)
    end
end

local function saveSessionData()
    if Sesh.sessionStart then
        local currentTime = (Sesh.paused and Sesh.pauseTime) or (Sesh.afkTime) or time()
        Sesh.sessionDuration = currentTime - Sesh.sessionStart
        Sesh.totalPlaytime = Sesh.totalPlaytime + Sesh.sessionDuration
        
        -- Save the data
        saveSeshData()

        -- Print save message if enabled
        if SeshSettings.showSaveMessages then
            print("Session data updated.")
        end
    end
end

local function stopSession()
    print("Stopping session")
    if not Sesh.sessionStart then
        print("No session to stop!")
        return
    end
    stopAceSeshTimer()
    print("Playtime tracking session stopped.")
    print("Session time: " .. getSessionDurationString())
    
    Sesh.totalPlaytime = Sesh.totalPlaytime + Sesh.sessionDuration
    Sesh.sessionStart = nil
    Sesh.sessionDuration = nil
    Sesh.paused = false
    Sesh.pauseTime = nil
    Sesh.timeLimit = nil
end
    
local function showSessionTime()
    if not Sesh.sessionStart then
        print("No active session!")
        return
    end
    print("Current session playtime: " .. getSessionDurationString())
end

local function showSessionLimit()
    if not Sesh.sessionStart then
        print("No active session!")
        return
    end
    if not Sesh.timeLimit then
        print("There is no limit on your current session.")
        return
    end
    print("Current session limit: " .. getTimeLimitString())
    print("Current session playtime: " .. getSessionDurationString())
end


local function pauseSession()
    if not Sesh.sessionStart then
        print("No active session to pause!")
        return
    end
    if Sesh.paused then
        print("Session is already paused! Current session is at ".. getSessionDurationString())
        return
    end
    Sesh.paused = true
    Sesh.pauseTime = time() -- Store the pause time
    print("Session paused at: " .. getSessionDurationString())
end


local function resumeSession()
    if not Sesh.sessionStart then
        print("No active session to resume!")
        return
    end
    if not Sesh.paused then
        print("Session is not paused!")
        return
    end
    local pausedDuration = time() - Sesh.pauseTime
    Sesh.sessionStart = Sesh.sessionStart + pausedDuration -- Adjust session start
    Sesh.paused = false
    Sesh.pauseTime = nil
    print("Session resumed. Session adjusted by pause time:" .. formatTime(pausedDuration))
end

_G["startSession"] = startSession
_G["toggleSaveMessages"] = toggleSaveMessages
_G["setWarningInterval"] = setWarningInterval
_G["saveSessionData"] = saveSessionData
_G["checkTimeLimit"] = checkTimeLimit
_G["stopSession"] = stopSession
_G["showSessionTime"] = showSessionTime
_G["showSessionLimit"] = showSessionLimit
_G["pauseSession"] = pauseSession
_G["resumeSession"] = resumeSession
_G["startAceSeshTimer"] = startAceSeshTimer
_G["stopAceSeshTimer"] = stopAceSeshTimer
_G["setTimeLimitFromString"] = setTimeLimitFromString
_G["setWarningInterval"] = setWarningInterval


-- Event Handlers
local function handleTimeLimit()
    local warningInterval = getWarningInterval()
    if Sesh.sessionStart and warningInterval then
        -- Check if the session time has reached the time limit, only if timeLimit is set
        if Sesh.timeLimit and Sesh.timeLimit > 0 then
            if Sesh.sessionDuration >= Sesh.timeLimit and not Sesh.timeLimitExceeded then
                local limitStr = getTimeLimitString()
                print("Time limit of " .. limitStr .. " reached!")
                Sesh.timeLimitExceeded = true
            end

            -- Check if the session has exceeded the time limit by at least the repeating warning interval
            if Sesh.sessionDuration > Sesh.timeLimit then
                local excessTime = Sesh.sessionDuration - Sesh.timeLimit
                
                -- Initialize lastWarningTime to 0 if it's nil
                Sesh.lastWarningTime = Sesh.lastWarningTime or 0
                
                -- Print warning only once every warningInterval seconds after the time limit is surpassed
                if excessTime >= warningInterval and (excessTime - Sesh.lastWarningTime >= warningInterval) then
                    print("Warning: Exceeded time limit by " .. formatTime(excessTime) .. "!")
                    Sesh.lastWarningTime = excessTime
                end
            end
        end
    end
end

local function handleLogin()
    local logoutDuration = Sesh.logoutTime and (time() - Sesh.logoutTime) or 0
    if Sesh.paused then
        print("Current session is paused at: " .. Sesh.sessionDuration .. " seconds.")
    elseif Sesh.sessionStart then
        Sesh.sessionStart = Sesh.sessionStart + logoutDuration
        startAceSeshTimer()
    end

    if Sesh.isLoggedOut then
        Sesh.isLoggedOut = false
        Sesh.logoutTime = nil
        print("Session resumed after being logged out for: " .. logoutDuration .. " seconds.")
        startAceSeshTimer()
    end
end

local function handleAFK()
    local isAFK = UnitIsAFK("player") 
    if Sesh.sessionStart and not Sesh.paused then
        if isAFK and not Sesh.afk then
            -- Player just went AFK
            Sesh.afk = true
            Sesh.afkTime = time() -- Record the time they went AFK
            print("Player is now AFK. Session paused.")
        elseif not isAFK and Sesh.afk then
            -- Player just returned from AFK
            local afkDuration = time() - (Sesh.afkTime or time())
            Sesh.sessionStart = Sesh.sessionStart + afkDuration -- Adjust session start
            Sesh.afk = false
            Sesh.afkTime = nil
            print("Player is no longer AFK. Session resumed. Adjusted for AFK time: " .. formatTime(afkDuration))
        end
    end
end

-- Assign the functions to global table _G to make them accessible across different files
_G["handleTimeLimit"] = handleTimeLimit
_G["handleLogin"] = handleLogin
_G["handleAFK"] = handleAFK
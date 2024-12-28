-- Slash command to start the timing session with optional time limit
SLASH_STARTTIMING1, SLASH_STARTTIMING2 = "/seshstart", "/shst"
SlashCmdList["STARTTIMING"] = startSession

-- Slash command to toggle showSaveMessages
SLASH_TOGGLESAVEMESSAGES1 = "/seshToggleSaveMsg"
SlashCmdList["TOGGLESAVEMESSAGES"] = toggleSaveMessages
    
-- Slash command to set the repeating warning interval
SLASH_WARNINGINTERVAL1, SLASH_WARNINGINTERVAL2 = "/seshSetWarningInterval", "/shwint"
SlashCmdList["WARNINGINTERVAL"] = setWarningInterval

-- Function to stop session
SLASH_STOPSESH1, SLASH_STOPSESH2 = "/seshstop", "/shsp"
SlashCmdList["STOPSESH"] = stopSession
    
-- Show current session playtime
SLASH_SESSIONTIME1, SLASH_SESSIONTIME2 = "/seshtime", "/sht"
SlashCmdList["SESSIONTIME"] = showSessionTime
    
-- Show current session playtime
SLASH_SESSIONLIMIT1, SLASH_SESSIONLIMIT2 = "/seshlimit", "/shlim"
SlashCmdList["SESSIONLIMIT"] = showSessionLimit
    
-- Pause session
SLASH_PAUSESESSION1, SLASH_PAUSESESSION2 = "/seshpause", "/shp"
SlashCmdList["PAUSESESSION"] = pauseSession

-- Resume session
SLASH_RESUMESESSION1, SLASH_RESUMESESSION2 = "/seshresume", "/shr"
SlashCmdList["RESUMESESSION"] = resumeSession
 
-- Create Frame for EventHandlers
frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")  -- Added PLAYER_LOGIN event
frame:RegisterEvent("PLAYER_LOGOUT") -- Ensure PLAYER_LOGOUT is registered
frame:RegisterEvent("PLAYER_FLAGS_CHANGED")

-- Save and load data
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MyPlaytimeTracker" then
        initaliseSeshData()
        if SeshSavedData then loadSeshData() end
    end

    if event == "PLAYER_LOGIN" then
        handleLogin()
    end

    if event == "PLAYER_FLAGS_CHANGED" then
        handleAFK()
    end

    if event == "PLAYER_LOGOUT" then
        Sesh.isLoggedOut = true
        Sesh.logoutTime = time() 
        saveSeshData()
        stopAceSeshTimer()
    end
end)
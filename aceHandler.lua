-- Function to handle periodic updates using AceTimer
local function AceSeshTimerHandler()
    saveSessionData()  
    handleTimeLimit()
end

_G["AceSeshTimerHandler"] = AceSeshTimerHandler
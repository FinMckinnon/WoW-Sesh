-- settings_data.lua (contains settings)
settingsCheckboxes = {
    {
        settingText = "Show Interval Save Messages",
        settingKey = "enableShowSaveMessages",
        settingTooltip = "While enabled, Interval Save Messages will be shown in chat.",
        defaultValue = false,
    },
    {
        settingText = "Enable tracking of Currency",
        settingKey = "enableCurrencyTracking",
        settingTooltip = "While enabled, your currency gained will be tracked.",
        defaultValue = false,
    },
}

multiInputs = {
    {
        settingText = "Set Session Limit",
        settingKey = "setSessionLimit",
        settingTooltip = "Sets a session limit Day Hour Minute Second",
        inputs= {
            {
                text = "Day",
                key= "setSessionLimitDay",
                isInt = true,
                unit = "d"
            },
            {
                text = "Hour",
                key= "setSessionLimitHour", 
                isInt = true,
                unit = "h"
            },
            {
                text = "Minute",
                key= "setSessionLimitMinute", 
                isInt = true,
                unit = "m"
            },
            {
                text = "Second",
                key= "setSessionLimitSecond", 
                isInt = true,
                unit = "s"
            },
        },
        button = {
            text = "Save",
            key= "setSessionLimitBtn"
        }
    }
}

settingsIntInputs = {
    {
        settingText = "Enter your name",
        settingKey = "userName",
        settingTooltip = "Enter your character's name here.",
        defaultValue = "", -- Default value if not set
    },
    {
        settingText = "Enter a custom message",
        settingKey = "customMessage",
        settingTooltip = "Enter a custom message to be displayed.",
        defaultValue = "", -- Default empty
    },
}

settingsData = {
    startSessionBtn = {
        {
            settingText = "Start Session",
            settingKey = "startSessionBtn",
            settingTooltip = "Start a Sesh Session.",
        }
    },
    setWarningIntervalInput={
        {
        settingText = "Set Warning Interval",
        settingKey = "setSeshWarningIntervalInput",
        settingTooltip = "Sets a the interval at which you will be warned when you exceed a session limit.",
        inputs= {
            {
                text = "Day",
                key= "setSeshWarningIntervalDay",
                isInt = true,
                unit = "d"
            },
            {
                text = "Hour",
                key= "setSeshWarningIntervalHour", 
                isInt = true,
                unit = "h"
            },
            {
                text = "Minute",
                key= "setSeshWarningIntervalMinute", 
                isInt = true,
                unit = "m"
            },
            {
                text = "Second",
                key= "setSeshWarningIntervalSecond", 
                isInt = true,
                unit = "s"
            },
        },
        button = {
            text = "Save",
            key= "setWarningIntervalBtn"
        }
    }
    },
    setSessionLimit={
        {
        settingText = "Set Session Limit",
        settingKey = "setSeshLimitInput",
        settingTooltip = "Sets the current sessions limit, or starts a new session with a given limit.",
        inputs= {
            {
                text = "Day",
                key= "setSessionLimitDay",
                isInt = true,
                unit = "d"
            },
            {
                text = "Hour",
                key= "setSessionLimitHour", 
                isInt = true,
                unit = "h"
            },
            {
                text = "Minute",
                key= "setSessionLimitMinute", 
                isInt = true,
                unit = "m"
            },
            {
                text = "Second",
                key= "setSessionLimitSecond", 
                isInt = true,
                unit = "s"
            },
        },
        button = {
            text = "Save",
            key= "setSeshLimitBtn"
        }
    }
    },
    stopSessionBtn= {
        {
        settingText = "Stop Session",
        settingKey = "stopSessionBtn",
        settingTooltip = "Stop a Sesh Session.",
        }
    },
    showSessionTimeCheckbox= {
        {
        settingText = "Show Session Time",
        settingKey = "showSessionTimeCheckbox",
        settingTooltip = "Show the current Sesh Session's duration on a counter.",
        }
    },
    showSessionLimitCheckbox= {
        {
        settingText = "Show Session Limit",
        settingKey = "showSessionLimitCheckbox",
        settingTooltip = "Show the current Sesh Session's limit.",
        }
    },
    pauseSessionBtn= {
        {
        settingText = "Pause Session",
        settingKey = "pauseSessionBtn",
        settingTooltip = "Pause the current Sesh Session.",
        }
    },
    resumeSessionBtn= {
        {
        settingText = "Resume Session",
        settingKey = "resumeSessionBtn",
        settingTooltip = "Resume the current Sesh Session.",
        }
    },
}
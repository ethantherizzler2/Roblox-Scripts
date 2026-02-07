local oldPrint, oldWarn, oldError = print, warn, error

local function SendLog(type, ...)
    local msg = table.concat({...}, "\t")
    pcall(DevconsoleLog, type, msg)
end

print = function(...)
    SendLog("INFO", ...)
    oldPrint(...)
end

warn = function(...)
    SendLog("WARN", ...)
    oldWarn(...)
end

error = function(...)
    SendLog("ERROR", ...)
    oldError(...)
end

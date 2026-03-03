-- Bypass for the Adonis anti cheat!!
local DEBUG = false
local Hooked = {}

local setidentity = setthreadidentity or set_thread_identity or setcontext
if setidentity then setidentity(2) end

local Detected, Kill
for _, v in pairs(getgc(true)) do
    if type(v) == "table" then
        if not Detected and rawget(v, "Detected") and type(v.Detected) == "function" then
            Detected = v.Detected
            
            local oldDetected
            oldDetected = hookfunction(Detected, function(Action, Info, NoCrash)
                if DEBUG then
                    warn(string.format("[Adonis] Flagged! Method: %s | Info: %s", tostring(Action), tostring(Info)))
                end
                return true 
            end)
            table.insert(Hooked, Detected)
        end

        if not Kill and rawget(v, "Kill") and rawget(v, "Variables") and rawget(v, "Process") then
            Kill = v.Kill
            hookfunction(Kill, function(Info)
                if DEBUG then warn("[Adonis] Prevented client kill: " .. tostring(Info)) end
                return 
            end)
            table.insert(Hooked, Kill)
        end
    end
    if Detected and Kill then break end
end

local oldDebugInfo
oldDebugInfo = hookfunction(getrenv().debug.info, newcclosure(function(lvl, info)
    if not checkcaller() and (lvl == Detected or lvl == Kill) then
        if DEBUG then warn("[Adonis] Blocked debug.info scan on hooks") end
        return coroutine.yield(coroutine.running())
    end
    return oldDebugInfo(lvl, info)
end))

if setidentity then setidentity(7) end

if DEBUG then print("fuck adonis") end

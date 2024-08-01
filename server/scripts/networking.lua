local requestCooldown = 1000
local lastRequestTimes = {}

RegisterServerEvent("kxm_utils:server:requestNativeSync", function(native, serverID, netID, ...)
    local src = source
    local currentTime = os.time()

    if lastRequestTimes[src] == nil or (currentTime - lastRequestTimes[src]) >= requestCooldown then
        lastRequestTimes[src] = currentTime
        TriggerClientEvent("kxm_utils:client:syncRequestedNative", serverID, native, netID, ...)
    else
        print("[KXM] Request from serverID " .. src .. " is being rate-limited.")
    end
end)

RegisterServerEvent("kxm_utils:sound:PlayPos", function(name, vol, coords, loop)
    local src = source
    exports.xsound:PlayUrlPos(src, name, "/html/sounds/" .. name .. ".mp3", vol, coords, loop)
end)

RegisterServerEvent("kxm_utils:sound:Play", function(name, vol, loop)
    local src = source
    exports.xsound:PlayUrl(src, name, "/html/sounds/" .. name .. ".mp3", vol, loop)
end)

RegisterServerEvent("kxm_utils:sound:Stop", function(name)
    local src = source
    exports.xsound:Destroy(src, name)
end)

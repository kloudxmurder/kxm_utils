kxm = kxm or {}
kxm.core = kxm.core or {}
kxm.minigame = kxm.minigame or {}
kxm.interface = kxm.interface or {}

SetInterval(function()
    collectgarbage("collect")
end, 30 * 1000)

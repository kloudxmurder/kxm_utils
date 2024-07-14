if GetResourceState("qb-target") ~= "started" or GetResourceState("ox_target") == "started" then return end
kxm.target = {}

kxm.target.disableTargeting = function(bool)
    exports['qb-target']:AllowTargeting(not bool)
end
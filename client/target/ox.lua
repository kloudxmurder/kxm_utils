if GetResourceState("ox_target") ~= "started" then return end
local target = exports.ox_target
kxm.target = {}

kxm.target.disableTargeting = function(bool)
    target:disableTargeting(bool)
end
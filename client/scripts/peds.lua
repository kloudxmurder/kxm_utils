local peds = {}

---@class pedData
---@field model string: automatically joaat'd
---@field coords vector4: z is automatically subtracted by one
---@field networked boolean

---Model is automatically requested thru ox_lib
---
---Models: https://docs.fivem.net/docs/game-references/ped-models/
---
---Returns created ped's entity ID
---@param data pedData
---@return entityID
kxm.create_ped = function(data)
    local model = joaat(data.model)
    lib.requestModel(model)

    local ped = CreatePed(3, model, data.coords.x, data.coords.y, data.coords.z - 1, data.coords.w, data.networked or false, true)

    peds[#peds+1] = {
        ped = ped,
        resource = GetInvokingResource()
    }

    SetModelAsNoLongerNeeded(model)
    return ped
end

AddEventHandler('onResourceStop', function(name)
    for k, v in pairs(peds) do
        if name == v.resource then
            SetEntityAsMissionEntity(v.ped)
            kxm.delete_entity(v.ped)
            peds[k] = nil
        end
    end
end)

local walk_style = 'default'
local can_change = true

kxm.set_walk = function(name)
    if not can_change then return end

    RequestClipSet(name)
    repeat Wait(100) until HasClipSetLoaded(name)

    walk_style = name

    if name == 'default' then
        ResetPedMovementClipset(cache.ped)
        return
    end

    SetPedMovementClipset(cache.ped, walk_style, 1.0)
    RemoveClipSet(walk_style)
end

kxm.reset_walk = function()
    if walk_style == 'default' then
        ResetPedMovementClipset(cache.ped)
    else
        kxm.set_walk(walk_style)
    end
end

kxm.get_walk = function()
    return walk_style
end

kxm.can_change_walk = function(bool)
    can_change = bool
end
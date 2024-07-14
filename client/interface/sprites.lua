local sprites_data = {}

---@class spriteData
---@field coords vector3
---@field key? string: lock, unlock, radial, eye, location, wheel, trunk, hood, person, basket, bank, dollar, garage, shirt, scissors, dot
---@field shape? string: circle, square, hex
---@field spriteIndicator? boolean
---@field colour? table: rgba {0, 0, 255, 255}
---@field onEnter? function
---@field onExit? function
---@field nearby? function: onTick
---@field distance? number
---@field canInteract? function
---@field scale? number
---@field boneId? number: will work and require for sprite_bone
---@field entity entityId: will work and require for sprite_bone and sprite_entity


---@param data spriteData
kxm.sprite = function(data)
    local id = exports.bl_sprites:sprite({
        coords = data.coords,
        key = data.key or nil,
        shape = data.shape or 'circle',
        spriteIndicator = data.spriteIndicator or false,
        colour = data.colour or {0, 0, 0, 0.63},
        canInteract = data.canInteract or function()
            return not kxm.is_busy()
        end,
        onEnter = data.onEnter or nil,
        onExit = data.onExit or nil,
        nearby = data.nearby or nil,
        distance = data.distance or 2.5,
        scale = data.scale or 0.025,
    })

    sprites_data[#sprites_data+1] = {
        id = id,
        resource = GetInvokingResource()
    }

    return id
end

---@param data spriteData
kxm.sprite_entity = function(data)
    local id = exports.bl_sprites:sprite({
        entity = data.entity,
        key = data.key or nil,
        shape = data.shape or 'circle',
        spriteIndicator = data.spriteIndicator or false,
        colour = data.colour or {0, 0, 0, 0.63},
        canInteract = data.canInteract,
        onEnter = data.onEnter or nil,
        onExit = data.onExit or nil,
        nearby = data.nearby or nil,
        distance = data.distance or 2.5,
        scale = data.scale or 0.025,
    })

    sprites_data[#sprites_data+1] = {
        id = id,
        resource = GetInvokingResource()
    }

    return id
end

---@param data spriteData
kxm.sprite_bone = function(data)
    local id = exports.bl_sprites:sprite({
        entity = data.entity,
        boneId = data.boneId,
        key = data.key or nil,
        shape = data.shape or 'circle',
        spriteIndicator = data.spriteIndicator or false,
        colour = data.colour or {0, 0, 0, 0.63},
        canInteract = data.canInteract,
        onEnter = data.onEnter or nil,
        onExit = data.onExit or nil,
        nearby = data.nearby or nil,
        distance = data.distance or 2.5,
        scale = data.scale or 0.025,
    })

    sprites_data[#sprites_data+1] = {
        sprite = id,
        resource = GetInvokingResource()
    }

    return id
end

kxm.remove_sprite = function(id)
    for k, v in pairs(sprites_data) do
        if id == v.id then
            sprites_data[k].id:removeSprite()
        end
    end
end

AddEventHandler('onResourceStop', function(name)
    for k, v in pairs(sprites_data) do
        if name == v.resource then
            sprites_data[k].id:removeSprite()
        end
    end
end)

---@class ProgressPropProps
---@field model string
---@field bone? number
---@field coords vector3
---@field rotation vector3

---@class ProgressProps
---@field label? string
---@field icon? string: Default: 'fas fa-spinner'
---@field duration number
---@field allowRagdoll? boolean
---@field allowCuffed? boolean
---@field allowFalling? boolean
---@field allowSwimming? boolean
---@field anim? { animDict?: string, anim: string, flags?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }
---@field prop? ProgressPropProps | ProgressPropProps[]
---@field propTwo? ProgressPropProps | ProgressPropProps[]
---@field disable? { move?: boolean, sprint?: boolean, car?: boolean, combat?: boolean, mouse?: boolean }
---@field canCancel? boolean
---@field useWhileDead? boolean

---@param data ProgressProps
kxm.progress = function(data)
    local finished = nil
    local cancelled = false

    local propsTbl = {
        model = data.prop?.model or nil,
        bone = data.prop?.bone or nil,
        coords = data.prop?.coords or nil,
        rotation = data.prop?.rotation or nil
    }

    if data.anim then
        kxm.play_anim({
            entity = cache.ped,
            dict = data.anim.dict,
            name = data.anim.name,
            upperbody = data.anim.upperbody,
            prop = propsTbl
        })
    end

    kxm.set_busy(true)

    exports['progressbar']:Progress({
        name = "random_task",
        duration = data.duration,
        label = data.label,
        useWhileDead = data.useWhileDead or false,
        canCancel = data.canCancel or false,
        allowRagdoll = data.allowRagdoll or false,
        allowSwimming = data.allowSwimming or false,
        allowCuffed = data.allowCuffed or false,
        allowFalling = data.allowFalling or false,
        controlDisables = {
            disableMovement = data.disable?.move or false,
            disableCarMovement = data.disable?.car or false,
            disableMouse = data.disable?.mouse or false,
            disableCombat = data.disable?.combat or false,
        },
        -- animation = data.anim or nil,
        -- prop = propsTbl,
    }, function(cancelled)
        if not cancelled then
            finished = true
        else
            cancelled = true
            finished = false
        end
    end)

    while finished == nil do
        Wait(10)
        if cancelled then
            kxm.set_busy(false)
            return false
        end
    end

    kxm.set_busy(false)
    if data.anim then
        kxm.stop_anim(cache.ped)
    end


    return finished
end

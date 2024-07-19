if not lib.checkDependency('qb-core', '1.2.6') then error() end

QB = exports['qb-core']:GetCoreObject()

local logged_in = false
local item_labels = {}

CreateThread(function()
    -- fill item_labels table from server
    item_labels = lib.callback.await('kxm_utils:server:getItemLabels', nil)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    exports.spawnmanager:setAutoSpawn(false)
    TriggerEvent('kxm_utils:client:playerLoaded')
    TriggerServerEvent('kxm_utils:server:playerLoaded')
    if QB.Functions.GetPlayerData().job.onduty then
        TriggerServerEvent('QBCore:ToggleDuty')
    end
    logged_in = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('kxm_utils:client:playerUnloaded')
    TriggerServerEvent('kxm_utils:server:playerUnloaded')
    logged_in = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    TriggerEvent('kxm_utils:client:jobUpdated')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData)
    TriggerEvent('kxm_utils:client:playerUpdated', PlayerData)

    StatSetInt(`BANK_BALANCE`, PlayerData.money.bank, true)
    StatSetInt(`MP0_WALLET_BALANCE`, PlayerData.money.cash, true)
end)

---@param type? string: job, jobname, jobgrade, jobboss, duty, money, bank, name, identifier, citizenid, inventory. Default: returns PlayerData table
local function getPlayerData(type)
    local PlayerData = QB.Functions.GetPlayerData()
    if type == 'job' then
        return PlayerData.job
    elseif type == 'jobname' then
        return PlayerData.job.name
    elseif type == 'jobgrade' then
        return PlayerData.job.grade.level
    elseif type == 'jobboss' then
        return PlayerData.job.isboss
    elseif type == 'duty' then
        return PlayerData.job.onduty
    elseif type == 'gang' then
        return PlayerData.gang
    elseif type == 'gangname' then
        return PlayerData.gang.name
    elseif type == 'ganggrade' then
        return PlayerData.gang.grade.level
    elseif type == 'gangrep' then
        return PlayerData.gang.reputation
    elseif type == 'money'then
        return PlayerData.money.cash
    elseif type == 'bank' then
        return PlayerData.money.bank
    elseif type == 'name' then
        return PlayerData.charinfo.firstname .. ' ' .. PlayerData.charinfo.lastname
    elseif type == 'identifier' then
        return PlayerData.license
    elseif type == 'citizenid' then
        return PlayerData.citizenid
    elseif type == 'inventory' then
        return PlayerData.items or {}
    elseif type == nil then
        return PlayerData
    else
        return PlayerData[type]
    end
end

kxm.core.getPlayerData = getPlayerData
exports('getPlayerData', getPlayerData)

---@param message string
---@param type string: info, error, success
---@param duration number
local function notify(message, type, duration, icon, iconColor)
    if type == 'info' then type = 'inform' end
    local notifData = {
        description = message,
        type = type or 'inform',
        duration = duration or 5000,
        position = 'top-right',
        icon = icon or nil,
        iconColor = iconColor or nil,
    }
    TriggerEvent('QBCore:Notify', notifData)
end

kxm.core.notify = notify
exports('notify', notify)

---@param item string: Item Name
---@return integer
local function getItemCount(item)
    local plyInv = getPlayerData('inventory')
    local invItems = {}
    local itemCount = 0
    for k, v in pairs(plyInv) do
        if v.name == item then
            itemCount = itemCount + v.count
        end
    end

    return itemCount or 0
end

kxm.core.getItemCount = getItemCount
exports('getItemCount', getItemCount)

---@param coords vector3 The coords to check from.
---@param maxDistance number The max distance to check.
---@param includePlayer boolean Whether or not to include the current player.
---@return number? playerServerId
---@return number? playerPed
---@return vector3? distance
local function getClosestPlayer(coords, maxDistance, includePlayer)
    coords = coords or GetEntityCoords(cache.ped)
    maxDistance = maxDistance or 3.0
    includePlayer = includePlayer or false

    local playerId, playerPed, playerCoords = lib.getClosestPlayer(coords, maxDistance, includePlayer)
    if not playerId then return end

    local distance = playerCoords and #(coords - playerCoords) or nil
    local playerServerId = GetPlayerServerId(playerId)

    return playerServerId, playerPed, distance
end

kxm.core.getClosestPlayer = getClosestPlayer
exports('getClosestPlayer', getClosestPlayer)

---@param coords vector3 The coords to check from.
---@param maxDistance number The max distance to check.
---@param includePlayer boolean Whether or not to include the current player.
---@return number? playerId
---@return number? playerPed
---@return vector3? playerCoords
local function getNearbyPlayers(coords, maxDistance, includePlayer)
    coords = coords or GetEntityCoords(cache.ped)
    maxDistance = maxDistance or 3.0
    includePlayer = includePlayer or false
    local nearbyPlayers = lib.getNearbyPlayers(coords, maxDistance, includePlayer)
    return nearbyPlayers
end

kxm.core.getNearbyPlayers = getNearbyPlayers
exports('getNearbyPlayers', getNearbyPlayers)

---@param coords vector3 The coords to check from.
---@param maxDistance number The max distance to check.
---@param includePlayerVehicle boolean Whether or not to include the player's current vehicle. Ignored on the server.
---@return number? vehicle
---@return vector3? distance
local function getClosestVehicle(coords, maxDistance, includePlayerVehicle)
    coords = coords or GetEntityCoords(cache.ped)
    maxDistance = maxDistance or 3.0
    includePlayerVehicle = includePlayerVehicle or false
    local vehicle, vehicleCoords = lib.getClosestVehicle(coords, maxDistance, includePlayerVehicle)
    if not vehicle or not vehicleCoords then return end

    return vehicle, #(coords- vehicleCoords)
end

kxm.core.getClosestVehicle = getClosestVehicle
exports('getClosestVehicle', getClosestVehicle)

---@return boolean Returns true if player is logged in
local function playerLoaded()
    return logged_in
end

kxm.core.playerLoaded = playerLoaded
exports('playerLoaded', playerLoaded)

---@param inv string|number
---@param item string
---@param amount integer
---@param meta? any
---@param slot? number
---@param reason? string
local function addItem(item, amount, meta, slot, reason)
    TriggerServerEvent('kxm_utils:server:addItem', GetPlayerServerId(PlayerId()), item, amount, meta, slot, reason)
end

kxm.core.addItem = addItem
exports('addItem', addItem)

---@param inv string|integer
---@param item string
---@param amount integer
---@param slot? number
---@param reason? any
local function removeItem(item, amount, meta, slot, reason)
    TriggerServerEvent('kxm_utils:server:removeItem', GetPlayerServerId(PlayerId()), item, amount, meta, slot, reason)
end

kxm.core.removeItem = removeItem
exports('removeItem', removeItem)

--- You can still use getItemCount, this is just a shortcut
---@param item string
---@param amount integer
---@return boolean: returns true if player has greater than or equal to the amount of the item
local function hasItem(item, amount)
    return getItemCount(item) >= amount
end

kxm.core.hasItem = hasItem
exports('hasItem', hasItem)

---@param key string
---@param value any
local function setPlayerMeta(key, value)
    TriggerServerEvent('kxm_utils:server:setPlayerMeta', key, value)
end

kxm.core.setPlayerMeta = setPlayerMeta
exports('setPlayerMeta', setPlayerMeta)

---@return any
local function getPlayerMeta()
    local playerMeta = QB.Functions.GetPlayerData().metadata
    return playerMeta
end

kxm.core.getPlayerMeta = getPlayerMeta
exports('getPlayerMeta', getPlayerMeta)

---@param type string: bank or money
---@param amount integer
---@param reason? string
local function removeMoney(type, amount, reason)
    TriggerServerEvent('kxm_utils:server:removeMoney', type, amount, reason)
end

kxm.core.removeMoney = removeMoney
exports('removeMoney', removeMoney)

---@param type string: bank or cash
local function getAccount(type)
    if type == 'cash' then type = 'money' end
    return getPlayerData(type)
end

kxm.core.getAccount = getAccount
exports('getAccount', getAccount)

---@param type string: bank or money
---@param amount integer
---@param reason? string
local function addMoney(type, amount, reason)
    TriggerServerEvent('kxm_utils:server:addMoney', type, amount, reason)
end

kxm.core.addMoney = addMoney
exports('addMoney', addMoney)

---@param type string: thirst, hunger, stress
---@param amount number
local function addStatus(type, amount)
    local playerData = kxm.core.getPlayerData()
    if type == 'thirst' then
        TriggerServerEvent('consumables:server:addThirst',  playerData.metadata.thirst + amount)
    elseif type == 'hunger' then
        TriggerServerEvent('consumables:server:addHunger', playerData.metadata.hunger + amount)
    elseif type == 'stress' then
        TriggerServerEvent('hud:server:GainStress', amount)
    end
end

kxm.core.addStatus = addStatus
exports('addStatus', addStatus)

---@param type string: thirst, hunger, stress
---@param amount number
local function removeStatus(type, amount)
    local playerData = kxm.core.getPlayerData()
    if type == 'thirst' then
        TriggerServerEvent('consumables:server:addThirst', playerData.metadata.thirst - amount)
    elseif type == 'hunger' then
        TriggerServerEvent('consumables:server:addHunger', playerData.metadata.hunger - amount)
    elseif type == 'stress' then
        TriggerServerEvent('hud:server:RelieveStress', amount)
    end
end

kxm.core.removeStatus = removeStatus
exports('removeStatus', removeStatus)

---@param item string
---@return string
local function getItemLabel(item)
    return item_labels[item] or 'Unknown'
end

kxm.core.getItemLabel = getItemLabel
exports('getItemLabel', getItemLabel)

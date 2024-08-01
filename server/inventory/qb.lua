local invStarted = false
local qbInv = nil
local invList = {
    qb = 'qb-inventory',
    lj = 'lj-inventory',
    ps = 'ps-inventory'
}

local invConvar = GetConvar('kxm:inventory', 'auto')
local isQB = false

if GetConvar('kxm:inventory', 'auto') ~= 'auto' then return end
if not invList[GetConvar('kxm:inventory', 'auto')] then return end

if GetResourceState(invList[invConvar]) ~= 'started' then
    if GetConvar('kxm:inventory', 'auto') ~= 'auto' then
        Wait(5000)
        print('^1kxm:inventory is set to ' .. invConvar .. ' but ' .. invList[invConvar] .. ' is not started.^7')
    end

    return
end

qbInv = exports[invList[invConvar]]
QB = exports['qb-core']:GetCoreObject()

local item_labels = {}

CreateThread(function()
    for item, data in pairs(QB.Shared.Items) do
        item_labels[item] = data.label
    end
end)

kxm = kxm
kxm.inv = {}

---@param source number
---@param item string
---@param amount number
---@param meta? table
---@param reason? string
local function addItem(source, inv, item, amount, meta, slot, reason)
    local player = QB.Functions.GetPlayer(inv)

    return player.Functions.AddItem(item, amount, slot, meta)
end

kxm.inv.addItem = addItem

local function removeItem(source, inv, item, amount, meta, slot, reason)
    local player = QB.Functions.GetPlayer(inv)

    return player.Functions.RemoveItem(item, amount, slot, reason)
end

kxm.inv.removeItem = removeItem

---@param player number | string: Inventory Name / Player ID
---@param item string: Item Name
---@return number
local function getItemCount(player, item)
    local plyInv = kxm.core.getPlayerData(player, 'inventory')
    local invItems = {}
    local itemCount = 0
    for k, v in pairs(plyInv) do
        if v.name == item then
            itemCount = itemCount + v.count
        end
    end

    return itemCount or 0
end

kxm.inv.getItemCount = getItemCount

--- You can still use getItemCount, this is just a shortcut
---@param item string
---@param amount integer
---@return boolean: returns true if player has greater than or equal to the amount of the item
local function hasItem(player, item, amount)
    return getItemCount(player, item) >= amount
end

kxm.inv.hasItem = hasItem

local function getItemLabels(source)
    return item_labels
end

local function getItemLabel(item)
    if not item_labels[item] then print(item .. ' is not in the item list.') end
    return item_labels[item] or 'Unknown'
end

kxm.inv.getItemLabel = getItemLabel
lib.callback.register('kxm_utils:server:getItemLabels', getItemLabels)

local function getInventoryItems(inv)
    return kxm.core.getPlayerData(inv, 'inventory')
end

kxm.inv.getInventoryItems = getInventoryItems

local function openInventory(invType, data)
    local src = source
    qbInv:OpenInventory(src, data)
end

kxm.inv.openInventory = openInventory

RegisterServerEvent('kxm_utils:server:openInventory', openInventory)

local function registerStash(id, label, slots, maxWeight, owner, groups, coords)
    -- not sure if qb inventory has one
end

kxm.inv.registerStash = registerStash

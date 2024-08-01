if GetResourceState('qs-inventory') ~= 'started' then return end
local qs = exports['qs-inventory']
local item_labels = {}

CreateThread(function()
    for item, data in pairs(qs:GetItemList()) do
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
    return qs:AddItem(inv, item, amount, slot, meta)
end

kxm.inv.addItem = addItem

local function removeItem(source, inv, item, amount, meta, slot, reason)
    return qs:RemoveItem(inv, item, amount, slot, meta)
end

kxm.inv.removeItem = removeItem

---@param player number | string: Inventory Name / Player ID
---@param item string: Item Name
---@return number
local function getItemCount(player, item)
    return qs:GetItemTotalAmount(player, item)
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

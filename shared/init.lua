kxm = kxm or {}

kxm.round = function(value, decimal)
    if not decimal then return math.floor(value + 0.5) end
    local power = 10 ^ decimal
    return math.floor((value * power) + 0.5) / (power)
end

local StringCharset = {}
local NumberCharset = {}
for i = 48, 57 do NumberCharset[#NumberCharset + 1] = string.char(i) end
for i = 65, 90 do StringCharset[#StringCharset + 1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset + 1] = string.char(i) end

kxm.randomStr = function(length)
    if length <= 0 then return '' end
    return kxm.randomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

kxm.randomInt = function(length)
    if length <= 0 then return '' end
    return kxm.randomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end

kxm.comma_value = function(amount)
    local formatted = amount
    local k
    while true do
        formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2')
        if k == 0 then
            break
        end
    end
    return formatted
end

kxm.time_percentage = function(millisecondsPassed, totalMilliseconds)
    local percentage = (millisecondsPassed / totalMilliseconds) * 100
    return string.format("%.2f%%", percentage)
end

exports("GetCore", function()
    return kxm
end)

SetInterval(function()
    collectgarbage("collect")
end, 30 * 1000)

CreateThread(function()
    if not IsDuplicityVersion() then return end

    local invList = {
        qb = 'qb-inventory',
        ps = 'ps-inventory',
        lj = 'lj-inventory',
        qs = 'qs-inventory',
        ox = 'ox_inventory'
    }

    local frameworkList = {
        qb = {
            name = 'qb-core',
            supported = true
        },
        esx = {
            name = 'es_extended',
            supported = false
        },
        ox = {
            name = 'ox_core',
            supported = false
        },
        nd = {
            name = 'ND_Core',
            supported = false
        },
    }
    Wait(7000)
    if GetConvar('kxm:inventory', 'auto') == 'auto' then
        for inv, name in pairs(invList) do
            if GetResourceState(name) == 'started' then
                print('^3kxm:inventory found ' .. name .. ' and set to ' .. inv .. '.^7')
                SetConvar('kxm:inventory', inv)
            end
        end
    end

    if GetConvar('kxm:framework', 'auto') == 'auto' then
        for framework, data in pairs(frameworkList) do
            if GetResourceState(data.name) == 'started' then
                if not data.supported then
                    print('^7kxm:framework found ' .. data.name .. ' but it\'s currently not supported.^7')
                else
                    print('^3kxm:framework found ' .. data.name .. ' and set to ' .. framework .. '.^7')
                end
                SetConvar('kxm:framework', framework)
            end
        end
    end
end)

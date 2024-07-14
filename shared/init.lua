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

exports("GetCore", function()
    return kxm
end)

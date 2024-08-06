kxm = kxm or {}
kxm.core = kxm.core or {}
kxm.minigame = kxm.minigame or {}
kxm.interface = kxm.interface or {}

local function GetLineCountAndMaxLenght(text)
    local count = 0
    local maxLenght = 0
    for line in text:gmatch("([^\n]*)\n?") do
        count = count + 1
        local lenght = string.len(line)
        if lenght > maxLenght then maxLenght = lenght end
    end
    return count, maxLenght
end

local function drawText3D(data)
    SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)

    local totalLenght = string.len(data.text)
    local textMaxLenght = data.textMaxLenght or 99 -- max 99
    local text = totalLenght > textMaxLenght and data.text:sub(1, totalLenght - (totalLenght - textMaxLenght)) or data.text

    SetDrawOrigin(data.coords.x, data.coords.y, data.coords.z, 0)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.0, 0.0)

    local count, lenght = GetLineCountAndMaxLenght(text)
    local padding = 0.005
    local heightFactor = (count / 43) + padding
    local weightFactor = (lenght / 100) + padding
    local height = (heightFactor / 2) - padding / 2
    local width = (weightFactor / 2) - padding / 2

    DrawRect(0.0, height, width, heightFactor, 0, 0, 0, 150)
    ClearDrawOrigin()
end

kxm.drawText3D = drawText3D
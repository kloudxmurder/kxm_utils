kxm.core = kxm.core or {}

local function checkVersion(name)
    PerformHttpRequest('https://raw.githubusercontent.com/kloudxmurder/kxm_versions/main/'.. name,
        function(err, content, headers)
            if not content then
                return
            end

            local version = string.gsub(content, '%s+', '')
            local currentVersion = LoadResourceFile(name, "version")

            if not currentVersion then
                currentVersion = GetResourceMetadata(name, 'version')
                local resourcePath = GetResourcePath(name)
                local newFile = io.open(resourcePath..'/version', 'w')
                newFile:write(currentVersion)
                newFile:close()

                if newFile then
                    print('[^5'.. name .. '^7] created version file. version: ' .. currentVersion)
                else
                    print('[^5'.. name .. '^7] ^1failed to create version file.^7')
                end
            end

            if version and version == currentVersion then
                print('[^5' .. name .. '^7] ^6You are running the latest version.^7')
            elseif version then
                print('[^5' .. name .. '^7] ^3Current^7: ' .. currentVersion .. '^3Latest^7: ' .. version)
                print('^1You are currently running an outdated version of ' .. name .. '.^7')
            end
        end
    )
end

RegisterServerEvent('onServerResourceStart', function(name)
    if string.find(name, 'kxm_') then
        Wait(5000)
        checkVersion(name)
    end
end)

CreateThread(function()
    Wait(4000)
    local ascii = {
        '  _  __      __  __    _____ _             _ _',
        ' | |/ /     |  \\/  |  / ____| |           | (_)',
        ' | \' / __  _| \\  / | | (___ | |_ _   _  __| |_  ___  ___',
        ' |  <  \\ \\/ / |\\/| |  \\___ \\| __| | | |/ _` | |/ _ \\/ __|',
        ' | . \\  >  <| |  | |  ____) | |_| |_| | (_| | | (_) \\__ \\',
        ' |_|\\_\\/_/\\_\\_|  |_| |_____/ \\__|\\__,_|\\__,_|_|\\___/|___/',
    }

    for k, v in ipairs(ascii) do
        print(v)
    end
end)

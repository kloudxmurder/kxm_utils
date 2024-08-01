kxm.core = kxm.core or {}

local function checkVersion(name)
    PerformHttpRequest('https://raw.githubusercontent.com/kloudxmurder/'.. name .. '/main/version',
        function(err, content, headers)
            if not content then
                return
            end

            local version = string.gsub(content, '%s+', '')

            local currentVersion = LoadResourceFile(name, "version")

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

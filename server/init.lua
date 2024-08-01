kxm.core = kxm.core or {}

local function checkVersion(name)
    PerformHttpRequest('https://raw.githubusercontent.com/kloudxmurder/'.. name .. '/main/version',
        function(err, content, headers)
            if not content then
                print('^8['.. name .. '] unable to check latest version.^7')
                return
            end

            local version = content:match("version%s+'([^']+)'")
            local currentVersion = GetResourceMetadata(name, 'version')

            if version and version == currentVersion then
                print('^6You are running the latest version.^7')
            elseif version then
                print('^3Version Check^7: ^2Current^7: ' .. currentVersion .. ' ^2Latest^7: ' .. version)
                print('^1You are currently running an outdated version of ' .. name .. '.^7')
            else
                print("Unable to extract version information from fxmanifest.lua.")
            end
        end
    )
end

RegisterServerEvent('onServerResourceStart', function(name)
    if string.find(name, 'kxm_') then
        -- Wait(5000)
        checkVersion(name)
    end
end)

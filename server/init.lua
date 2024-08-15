kxm.core = kxm.core or {}

local function checkVersion(name)
    PerformHttpRequest('https://raw.githubusercontent.com/kloudxmurder/kxm_versions/main/'.. name,
        function(err, content, headers)
            if not content then
                return
            end

            local version = string.gsub(content, '%s+', '')
            local currentVersion = GetResourceMetadata(name, 'version')

            if not currentVersion then
                return
            end

            if version and version == currentVersion then
                print('[^5' .. name .. '^7] ^6You are running the latest version. v' .. currentVersion .. '^7')
            elseif version then
                print('[^5' .. name .. '^7] ^3Current^7: v' .. currentVersion .. '^3 Latest^7: v' .. version)
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
        '^1K  K     M   M      SSS   t          d            ^7',
        '^1K K      MM MM     S      t          d ii         ^7',
        '^1KK   x x M M M      SSS  ttt u  u  ddd    ooo  ss ^7',
        '^1K K   x  M   M         S  t  u  u d  d ii o o  s  ^7',
        '^1K  K x x M   M     SSSS   tt  uuu  ddd ii ooo ss  ^7',
        '^2Discord: ^7https://discord.gg/76K49H3t9D',
        '^2Tebex: ^7https://kxm.tebex.io'
    }

    for k, v in ipairs(ascii) do
        print(v)
    end

    print('^2 --- VERSION CHECK ---^7')
    Wait(1800)
    print('^2 --- SET CONVARS ---^7')
end)

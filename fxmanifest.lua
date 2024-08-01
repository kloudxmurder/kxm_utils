fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'kxm_utils'
description 'Kloud x Murder Studios | Developer Utililties'
author 'kxm'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    -- 'shared/init.lua',
    'shared/**/*'
}

client_scripts {
    'client/init.lua',
    'client/framework/*',
    'client/inventory/*',
    'client/scripts/*',
    'client/minigame/*',
    'client/target/*',
    'client/interface/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/init.lua',
    'server/framework/*',
    'server/inventory/*',
    'server/scripts/*',
}

dependencies {
    'ox_lib',
    'oxmysql'
}

escrow_ignore {
    'shared/*'
}

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'kxm_utils'
description 'Kloud x Murder Studios | Developer Utililties'
author 'kxm'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/init.lua',
    'shared/**/*'
}

client_scripts {
    'client/init.lua',
    'client/**/*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/init.lua',
    'server/**/*'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

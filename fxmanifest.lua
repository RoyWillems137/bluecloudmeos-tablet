fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

author 'BlueCloud MEOS'
description 'BlueCloud MEOS tablet script'
version '1.3'

ui_page 'html/index.html'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/events.lua',
    'client/commands.lua'
}

server_scripts {
    'config.lua',
    'server/version.lua',
    'server/main.lua'
}

files {
    'html/index.html',
    "html/img/*.png",
    'html/css/*.css',
    "html/js/*.js",
}

escrow_ignore 'config.lua'

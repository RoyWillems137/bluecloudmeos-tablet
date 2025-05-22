fx_version 'cerulean'
games { 'gta5' }

author 'BlueCloud MEOS'
description 'BlueCloud MEOS tablet script'
version '1.0'

ui_page 'html/index.html'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/events.lua',
    'client/commands.lua'
}

files {
    'html/index.html',
    "html/img/*.png",
    'html/css/*.css',
    "html/js/*.js",
}

fx_version 'cerulean'

game { 'gta5' }

author 'MaximumQc'
description 'Simple script "antilag" for FiveM'
version '1.0.0'

ui_page('html/index.html')

client_scripts {
    'config/config.lua',
    'client.lua'
}

server_script 'server.lua'

files {
    'html/index.html',
    'html/sounds/**'
}

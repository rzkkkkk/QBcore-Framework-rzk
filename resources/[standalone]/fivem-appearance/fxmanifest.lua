fx_version "cerulean"
game { "gta5" }

author 'ihyajb#9723'
description 'A flexible player customization script for FiveM. Made to work with QBCore'
repository 'https://github.com/ihyajb/aj-fivem-appearance'
version 'v1.3.0'

shared_script 'config.lua'

client_scripts {
  'game/build/client.js',
  'client/client.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/server.lua',
  'server/version.lua',
}


files {
  'web/build/index.html',
  'web/build/static/js/*.js',
  'locales/*.json',
  'peds.json'
}

ui_page 'web/build/index.html'

provide 'qb-clothing'
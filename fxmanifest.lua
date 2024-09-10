fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'Rayaan Uddin'
name "ez_lib" -- Do not change this.
version "1.1"
description "[QB/ESX/Other] EZ Scripts Library"


shared_scripts { 'config.lua'} -- Remove ox_lib if you are not using it

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- Remove oxmysql if you are not using it
	-- '@mysql-async/lib/MySQL.lua', -- Remove mysql-async if you are not using it
    'server/*.lua',
    'server/**/*.lua'
}

client_scripts {
    'client/*.lua', 'client/**/*.lua',
    '@PolyZone/client.lua', '@PolyZone/BoxZone.lua', '@PolyZone/EntityZone.lua', '@PolyZone/CircleZone.lua', '@PolyZone/ComboZone.lua'
}
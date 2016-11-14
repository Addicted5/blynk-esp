print ( "Starting blynk example" )

token = "YourSecretToken"
wifi_password = "12345678"
wifi_access_point = "BlynkIt"

-- better to compile blynk.lua, wifi.lua to lc if you are not modifying it

-- Load the Blynk library
dofile ( 'blynk.lua' )
-- Load application part
dofile ( 'application.lua' )
-- connect to WiFi 
dofile ( 'wifi.lua' )

function connecting(wifi_ssid, wifi_password)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(wifi_ssid, wifi_password)

    tmr.alarm(0, 500, 1, function()
        if wifi.sta.getip()==nil then
          print("Connecting to AP...")
        else
          tmr.stop(1)
          tmr.stop(0)
          print("Connected as: " .. wifi.sta.getip())
          b = blynk.new ( token, 4, set_callbacks ):connect()
        end
    end)

    tmr.alarm(1, 15000, 0, function()
        if wifi.sta.getip()==nil then
            tmr.stop(0)
            print("Failed to connect to \"" .. wifi_ssid .. "\"")
        end
    end)
end



if wifi_access_point == "" and wifi_password == "" then
   print ("=============\nPlease edit init.lua and set:\n\tWiFi Access Point\n\tPassword\n\tBlynk token")
   print ("=============")
else
   if wifi.sta.getip()==nil then
      print ( "connecting to AP..." )
      connecting(wifi_access_point, wifi_password)
   else
      print ("already connected")
      b = blynk.new ( token, 4, set_callbacks ):connect()
   end
end

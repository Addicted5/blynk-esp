function set_callbacks(b)

   --[[ Virtual pins are
      0 -- RED
      1 -- GREEN
      2 -- BLUE
      5 -- BUTTON
      10 -- VALUE OF RED
      11 -- VALUE OF GREEN
      12 -- VALUE OF BLUE
   ]]--
   -- virtual to "lua" pin
   local write_pins = { ['0']=2, ['1']=1, ['2']=4 }
   local read_pins = { ['5']=3 }
   -- red == 2
   gpio.mode(2, gpio.OUTPUT)
   -- blue == 4
   gpio.mode(4, gpio.OUTPUT)
   -- green = 1
   gpio.mode(1, gpio.OUTPUT)
   gpio.mode(3, gpio.INPUT)
   -- The controller wants to write to a pin
   b:on ( 'vw', function(cmd)
             local pin = cmd[2]
             local value = tonumber(cmd[3])
             if write_pins[pin] ~= nil then
                pwm.setup(write_pins[pin], 500, value)
                pwm.start(write_pins[pin])
             end
   end)

   -- The controller wants to read a pin
   -- we must respond with the same message id
   b:on ( 'vr', function(cmd, original_mid)
             local mid = b:mid()
             local pin = cmd[2]
             print ( "read virtual pin " .. pin)
             if read_pins[pin] ~= nil then
                local value = gpio.read(read_pins[pin])
                print ( "virtual pin " .. pin .. " value " .. value .. ' message id ' .. mid)
                b:send_message(blynk.commands["hardware"], original_mid, b:pack('vw', '5', tostring(value)))
             else
                -- always send back hello, for any other pin
                b:send_message(blynk.commands["hardware"], original_mid, b:pack('vw', pin, 'HELLO'))
             end
   end)
   
   -- ESPToy button
   local button = 3
   gpio.mode(button, gpio.INT)
   gpio.trig(button, "down", function(level)
                print ( "pushed button")
                b:send_message(blynk.commands["notify"], b:mid(), "you pushed a button")
   end)
end

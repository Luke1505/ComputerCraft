local mon = peripheral.find("monitor")

-- make gui for the monitor
-- make buttons for containers and show the "Train"
-- make logic to unlock the container 

local function move_to_container(container_index,load_unload)
    if load_unload == "unload" then
        rednet.send(11, {"unload " , container_index}, "table")
    end
    -- move to the container
    -- load/unload the container
    -- lock the container
    -- return to start position
end

local function got_to_initial()
    -- go back to start Position
end
--redstone.setAnalogOutput("Axis Y", 0)
--redstone.setAnalogOutput("Axis X", 0)
--redstone.setAnalogOutput("Axis Z", 0)
--redstone.setAnalogOutput("spin rotation", 0)
--redstone.setAnalogOutput("loader", 0)
--redstone.setAnalogOutput("assembler", 0)
--redstone.setAnalogOutput("unlock from train", 0)
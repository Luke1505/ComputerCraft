local mon = peripheral.find("monitor")

-- make gui for the monitor
-- make buttons for containers and show the "Train"
-- make logic to unlock the container 

local function move_to_container(container_index,load_unload)
    --load_unload = true for loading, false for unloading
    if container_index == 1 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 2 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 3 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 4 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 5 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 6 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 7 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 8 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 9 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 10 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 11 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 12 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 13 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 14 then
        -- do redstone move thingy here
        print(container_index)
        return
    elseif container_index == 15 then
        -- do redstone move thingy here
        print(container_index)
        return
    else 
        printError("Container index out of range")
        return
    end
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
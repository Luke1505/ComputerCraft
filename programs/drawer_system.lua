local chests = {peripheral.find("storagedrawers:controller")}
local data_monitor = peripheral.find("monitor")
local sleep_time = sleep(#(chests)/20)
data_monitor.setTextScale(0.5)

local function move_line()
    data_monitor.setCursorPos(1, select(2, data_monitor.getCursorPos()) + 1)
    if select(2, data_monitor.getCursorPos()) >= select(2, data_monitor.getSize()) then
        data_monitor.scroll(1)
        data_monitor.setCursorPos(1, select(2, data_monitor.getCursorPos()) - 1)
    end
end

local function add(list, taken, name, max)
    local success = false
    for _, v in ipairs(list) do 
        if v.name == name then 
            v.taken = v.taken + taken
            v.max = v.max +max
            success = true
        end
    end
    if not success then
        table.insert(list,{["taken"] = taken,["name"] = name, ["max"] = max})
    end
end

local function get_drawers(chest)
    local count = chest.size()
    local name = ""
    local max = 0
    local taken = 0
    local drawerss = {}
    if count > 1 then
        for i=2 ,count do
            if (chest.getItemDetail(i) == nil) then
                taken = 0
                name = "Free Space"
            else
                taken = chest.getItemDetail(i).count
                name = chest.getItemDetail(i).displayName
            end
            add(drawerss,taken,name, chest.getItemLimit(i))
        end
    end
    return drawerss
end
    
local function get_drawer_data(drawer)
    local name = drawer["name"]
    local max = drawer["max"]
    local taken = drawer["taken"]
    return name , taken ,max     
end

local function make_progressbar(size, taken, max)
    size = size - 2 -- make space for "[" and "]"
    --[[
    taken/max = x/size
    taken * size = x * max
    x = taken * size / max
    ]]
    local progress = math.floor(size * taken / max)
    local hash = ("#"):rep(progress)
    local dots = ("."):rep(size - progress)
    return ("[" .. hash .. dots .. "]")
end

local function write_progressbar(taken, max)
    -- Progressbar
    local percent = 100 - math.floor(100 * taken/max)
    local taken_space = #tostring(percent) + #tostring(taken) + #tostring(max) + 11  -- " taken/free [PROGRESSBAR] percent% free "
    local size = select(1, data_monitor.getSize()) - taken_space

    data_monitor.write(" " .. tostring(taken) .. "/" .. tostring(max) .. " " .. make_progressbar(size, taken, max) .. " ".. percent .. "% free")
    move_line()
end

local function write_chest_data(index, taken, max)
    local size = select(1, data_monitor.getSize())
    local start = index .. (" "):rep(8 - #tostring(index) - #tostring(taken)) .. " " .. tostring(taken) .. "/" .. tostring(max) ..  (" "):rep(5 - #tostring(max))
    data_monitor.write(start .. make_progressbar(20, taken, max))
end

while true do
    local max_storage = 0
    local taken_storage = 0
    local chests_list = {}
    for i, chest in pairs(chests) do
        local drawers = get_drawers(chest)
        for i, drawer in ipairs(drawers) do
            local name, taken, max = get_drawer_data(drawer)

            taken_storage = taken_storage + taken
            max_storage = max_storage + max
            add(chests_list,taken,name,max)
         
        end
    end

    data_monitor.clear()
    data_monitor.setCursorPos(1, 1)
    write_progressbar(taken_storage, max_storage)
    for i, chest in pairs(chests_list) do
        write_chest_data(chest["name"], chest["taken"], chest["max"])
        move_line()
    end

    sleep(sleep_time)
end

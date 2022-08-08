local chests = { peripheral.find("storagedrawers:controller") }
--local data_monitor = peripheral.find("monitor")
os.loadAPI("bigfont")
local data_monitor = peripheral.wrap("right") -- temp
local sleep_time = 30
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
            v.max = v.max + max
            success = true
                    end
    end
    if not success then
        table.insert(list, { ["taken"] = taken, ["name"] = name, ["max"] = max })
    end
end

local function get_drawers(chest)
    local count = chest.size()
    local name = ""
    local taken = 0
    local drawerss = {}
    if count > 1 then
        for i = 2, count do
            if (chest.getItemDetail(i) == nil) then
                taken = 0
                name = "Free Space"
            else
                taken = chest.getItemDetail(i).count
                name = chest.getItemDetail(i).displayName
            end
            add(drawerss, taken, name, chest.getItemLimit(i))
        end
    end
    return drawerss
end

local function get_drawer_data(drawer)
    local name = drawer["name"]
    local max = drawer["max"]
    local taken = drawer["taken"]
    return name, taken, max
end

local function process_drawers(controller, chest_list)
    for _, chest in ipairs(controller) do
        local drawers = get_drawers(chest)
        for _, drawer in ipairs(drawers) do
            local name, taken, max = get_drawer_data(drawer)
            add(chest_list, taken, name, max)
        end
    end
end

local function make_progressbar(size, taken, max)
    size = size - 2
    local progress = math.floor(size * taken / max)
    local hash = ("#"):rep(progress)
    local dots = ("."):rep(size - progress)
    return ("[" .. hash .. dots .. "]")
end

local function write_progressbar(taken, max)
    -- Progressbar
    local percent = math.floor(100 * taken / max)
    local x,y = data_monitor.getCursorPos() 
    local taken_space = #tostring(percent) + #tostring(taken) + #tostring(max) + 11 -- " taken/free [PROGRESSBAR] percent% free "
    local size = select(1, data_monitor.getSize()) - taken_space
    data_monitor.write(" " ..
        tostring(taken) .. "/" .. tostring(max) .. " " .. make_progressbar(size, taken, max) .. " " ..
        percent .. "%")
    data_monitor.setCursorPos(97,y)
    data_monitor.write("used")
    move_line()
end

local function write_chest_data(index, taken, max)
    local size = select(2, data_monitor.getSize())
    size = size - 21
    local itemName = " " .. index
    local counter = tostring(taken) .. "/" .. tostring(max)
    local percent = math.floor(100 * taken / max)
    local x, y = data_monitor.getCursorPos()
    data_monitor.write(itemName)
    data_monitor.setCursorPos(45, y)
    data_monitor.write(counter)
    data_monitor.setCursorPos(60, y)
    data_monitor.write(make_progressbar(size, taken, max))
    data_monitor.write(" " .. percent .. "%")
    data_monitor.setCursorPos(97,y)
    --data_monitor.write("used")
end

-- variable declarations so that they're availablse beyond the scope where they'll be changed
local current_page = 1 -- current page
local pages = {}
local max_storage
local taken_storage
local arrow_left_x -- x positions of left and right arrows
local arrow_right_x

local function scan_chests() -- you currently have this in your loop, but having this in a function would be a bit more convenient for what we're gonna do
    max_storage = 0
    taken_storage = 0
    pages = {}
    local calls = {}
    local chests_list = {}
    for i, chest in pairs(chests) do
        table.insert(calls, process_drawers(chest, chests_list))
    end
    parallel.waitForAll(table.unpack(calls))
    -- up to this point it was basically what you were doing already. We now need to order the chests_list table alphabetically.
    -- To do this, we're gonna create a sort function that will be fed to table.sort that'll sort based on the name field in the chests_list entries.
    table.sort(chests_list, function(a, b) return a.name < b.name end)
    -- now our table is sorted. We can now add it into pages.
    local w, h = data_monitor.getSize() -- we need to get the size of the screen to see how many entries would fit
    local maxEntries = h - 3 -- leave 1 row for progress bar and another for page arrows
    for i = 1, #chests_list do
        local p = math.ceil(i / maxEntries)
        pages[p] = pages[p] or {}
        table.insert(pages[p], chests_list[i])
    end
    -- now we have our pages
end

local function render() -- we don't want to render every event, so having it in a function would be more convenient
    data_monitor.clear()
    data_monitor.setCursorPos(1, 1)
    write_progressbar(taken_storage, max_storage)
    for i, chest in ipairs(pages[current_page]) do
        write_chest_data(chest["name"], chest["taken"], chest["max"])
        move_line()
    end

    -- draw page arrows
    local w, h = data_monitor.getSize()
    local txt = " \27" .. current_page .. "/" .. #pages .. "\26 "
    local x, y = math.floor(w / 2 - #txt / 2) + 1,  h
    data_monitor.setCursorPos(x, y) -- centered on bottom row
    data_monitor.write(txt) -- write arrows
end

scan_chests() -- naturally we need a scan to begin
render() -- and we'll want to see the screen
--local timer_id = os.startTimer(sleep_time) -- we need timers because we can't use sleep with os.pullEvent
local function touch()
    while true do
        local e = { os.pullEvent() } -- listen for events and put them in a table called "e"
        local w, h = data_monitor.getSize()
        if e[1] == "monitor_touch" then -- if the monitor was touched on the bottom row
            if (e[3] / w) <     0.5 and current_page > 1 then -- if left arrow was touched and theres a page on the left side (not the case if we're on page 1)
                current_page = current_page - 1
                render() -- so that we can see the new page
            elseif (e[3] / w) > 0.5 and current_page < #pages then -- if right arrow was touched and theres a page on the right side (not the case if we're on the last page)
                current_page = current_page + 1
                render()
            end
            --[[elseif e[1] == "timer" and e[2] == timer_id then -- if our timer expired then scan for chests again like your original code
			scan_chests()
			render()
			timer_id = os.startTimer(sleep_time) -- start a new timer]]
        end
    end
end

local function keep_up_to_date()
    while true do
        scan_chests()
        render()
        os.sleep(sleep_time)
    end
end

parallel.waitForAny(touch, keep_up_to_date)
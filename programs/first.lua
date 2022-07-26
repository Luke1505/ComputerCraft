local bbf = require("blbfor")

local handle = bbf.open_url("https://github.com/Luke1550/ComputerCraft/raw/main/pictures/PepeSmile.bbf")
local DISPLAY_ON = term.current()

local win = window.create(DISPLAY_ON, 1, 1, DISPLAY_ON.getSize())

while true do
    for layer = 1, handle.layers do
        for line = 1, handle.height do
            win.setCursorPos(1, line)
            win.blit(handle:read_line(layer, line))
            for k, v in pairs(handle.meta.palette[1]) do
                win.setPaletteColor(2 ^ tonumber(k), v)
            end
        end
        sleep(0.05)
    end
end

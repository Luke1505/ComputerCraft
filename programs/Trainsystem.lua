local basalt = require("Basalt")

local mainFrame = basalt.createFrame("mainFrame"):show()
local button = mainFrame --> Basalt returns an instance of the object on most methods, to make use of "call-chaining"
        :addButton("clickableButton") --> This is an example of call chaining
        :setPosition(4,4) 
        :setText("Click me!")
        :onClick(
            function() 
                basalt.debug("I got clicked!") 
            end)
        :show()

basalt.autoUpdate()
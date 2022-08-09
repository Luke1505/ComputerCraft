peripheral.find("modem", rednet.open)
while true do
    local event, sender, message, protocol = os.pullEvent("rednet_message")
    if protocol == "table" and sender == 11 then
        local command = message[1]
        if command == "unload" then
            -- do unattach the container

        end
        if command == "load" then
            -- do reattach the container to the train
        end
        if command == "assemble" then
            --send redstone signal and return to start position
        end
    end
end

local ccOs = {}
local love = _G.love
local osUpdateChannel = love.thread.newChannel("os_update")

ccOs.shutdown = function()
    osUpdateChannel:push({
        type = "shutdown"
    })
end

ccOs.startTimer = function(time)
    for i, v in pairs(_G.os) do
        log(i, v)
    end
    osUpdateChannel:push({
        type = "startTimer",
        at = os.time() + time
    })
    log(time)
end

ccOs.pullEvent = function(filter)
    while true do
        local msg = osUpdateChannel:pop()
        if msg then 
            if msg.type == "event" then
                if msg.eventType == filter or filter == nil then
                    return table.unpack(msg.args)
                end
            end
        end 
        love.timer.sleep(0.05)
    end
end

return ccOs
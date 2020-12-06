local osSvc = {}
local osUpdateChannel = love.thread.newChannel("os_update")

local timers = {}

osSvc.run = function(thread)
    local msg = osUpdateChannel:pop()

    if msg then
        if msg.type == "shutdown" then
            thread:release()
        elseif msg.type == "startTimer" then
            table.insert(timers, msg.at)
        end
    end


end

return osSvc
local osSvc = {}
local osUpdateChannel = love.thread.newChannel("os_update")

osSvc.run = function(thread)
    local msg = osUpdateChannel:pop()

    if msg then
        if msg.type == "shutdown" then
            thread:release()
        end
    end
end

return osSvc
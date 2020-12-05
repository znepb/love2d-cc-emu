local os = {}
local love = _G.love
local osUpdateChannel = love.thread.newChannel("os_update")

os.shutdown = function()
    osUpdateChannel:push({
        type = "shutdown"
    })
end

return os  
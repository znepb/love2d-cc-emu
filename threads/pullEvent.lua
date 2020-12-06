local args = { ... }
local osUpdateChannel = args[1]
local love = args[2]

while true do
    local msg = osUpdateChannel:pop()
    if msg then
        if msg.type == filter or filter == nil then

        end
    end 
    love.timer.sleep(0.05)
end
local rs = {}
local love = _G.love

rs.getSides = function()
    return {"top", "bottom", "left", "right", "front", "back"}, "Notice: Although this API exists in the emulator, it only exists to make the bios work."
end

return rs
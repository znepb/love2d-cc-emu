local cX, cY = 1, 1
local textColor = 1
local backgroundColor = 32768
local term = {}
local love = _G.love
local termSize = _G.termSize
local termUpdateChannel

local colorToChar = {
    "0",
    "1",
    [4] = "2",
    [8] = "3",
    [16] = "4",
    [32] = "5",
    [64] = "6",
    [128] = "7",
    [256] = "8",
    [512] = "9",
    [1024] = "a",
    [2048] = "b",
    [4096] = "c",
    [8192] = "d",
    [16384] = "e",
    [32768] = "f"
}

term.nativePaletteColor = function(color)
    if nativePallet[color] then
        local p = nativePallet[color]
        return p[1], p[2], p[3]
    end
end
term.nativePaletteColour = term.nativePaletteColor

term.write = function(text)
    termUpdateChannel:push({
        type = "blit",
        x = cX,
        y = cY,
        text = text,
        bgColor = string.rep(colorToChar[backgroundColor], #text),
        fgColor = string.rep(colorToChar[textColor], #text)
    })
end

term.setTextColor = function(color)
    textColor = color  
end

term.setBackgroundColor = function(color)
    backgroundColor = color  
end

term.setTextColour = term.setTextColor
term.setBackgroundColour = term.setBackgroundColour

term.getTextColor = function()
    return textColor
end

term.getBackgroundColor = function()
    return backgroundColor
end

term.getTextColour = term.getTextColor
term.getBackgroundColour = term.getBackgroundColour

term.setCursorPos = function(x, y)
    cX, cY = x, y
end

term.getSize = function()
    return termSize.x, termSize.y
end

term.getCursorPos = function()
    return cX, cY
end

term.clear = function()
    termUpdateChannel:push({
        type = "clear",
        bgColor = colorToChar[backgroundColor],
        fgColor = colorToChar[textColor]
    }) 
end

term.scroll = function()
    termUpdateChannel:push({
        type = "scroll",
        bgColor = colorToChar[backgroundColor],
        fgColor = colorToChar[textColor]
    })
end

-- term.isColor will always return true, because (currently) the terminal is always advanced.
term.isColor = function() return true end
term.isColour = term.isColor

term.setTermUpdateChannel = function(channel)
    print("channel set")
    termUpdateChannel = channel
    term.setTermUpdateChannel = nil
end
    

return term
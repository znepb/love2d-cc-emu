local display = {}
local fontImages = {}
local termSize = _G.termSize

display.nativePallet = {
    [1] = {240, 240, 240},
    [2] = {242, 178, 51},
    [4] = {229, 127, 216},
    [8] = {153, 178, 242},
    [16] = {222, 222, 108},
    [32] = {127, 204, 25},
    [64] = {242, 178, 204},
    [128] = {72, 72, 72},
    [256] = {153, 153, 153},
    [512] = {76, 153, 178},
    [1024] = {178, 102, 229},
    [2048] = {51, 102, 204},
    [4096] = {127, 102, 76},
    [8192] = {87, 166, 78},
    [16384] = {204, 76, 76},
    [32768] = {17, 17, 17}
}

display.letterColors = {
    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 4,
    ["3"] = 8,
    ["4"] = 16,
    ["5"] = 32,
    ["6"] = 64,
    ["7"] = 128,
    ["8"] = 256,
    ["9"] = 512,
    ["a"] = 1024,
    ["b"] = 2048,
    ["c"] = 4096,
    ["d"] = 8192,
    ["e"] = 16384,
    ["f"] = 32768
}

display.pallet = display.nativePallet

local fontImage = love.graphics.newImage("resources/term_font.png")
fontImage:setFilter("linear", "nearest")

-- Create sprite quads for font
local img = 0
for i = 0, 15 do
    for j = 0, 15 do
        fontImages[img] = love.graphics.newQuad(j * 8, i * 11, 8, 11, fontImage:getDimensions())
        img = img + 1
    end
end

for i, v in pairs(display.nativePallet) do
    local t = {}
    for i, v in pairs(v) do
        t[i] = v / 255
    end
    display.nativePallet[i] = t
end

local function getHexFromPallet(hex)
    return display.pallet[display.letterColors[hex]]
end

local dbl = {string.rep(" ", termSize.x), string.rep("0", termSize.x), string.rep("f", termSize.x)} -- default blit line

display.blit = {dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl, dbl}

function display.drawBlitCharacter(char, textColor, backgroundColor, x, y)
    x = x - 1
    y = y - 1

    local realBackgroundColor = getHexFromPallet(backgroundColor)
    local realTextColor = getHexFromPallet(textColor)

    love.graphics.setColor(realBackgroundColor)

    local function drawBackgroundBox()
        local dX, dY, dW, dH = 0, 0, 0, 0

        if x == 0 or x == termSize.x - 1 then
            dW = 8
            if x == termSize.x - 1 then
                dX = x * 6 + 2
            end
        else
            dX = x * 6 + 2
            dW = 6
        end

        if y == 0 or y == termSize.y - 1 then
            dH = 11
            if y == termSize.y - 1 then
                dY = y * 9 + 2
            end
        else
            dY = y * 9 + 2
            dH = 9
        end

        love.graphics.rectangle("fill", dX, dY, dW, dH)
    end

    drawBackgroundBox()

    love.graphics.setColor(realTextColor)
    love.graphics.draw(fontImage, fontImages[string.byte(char)], x * 6 + 1, y * 9 + 1)
end

function display.drawBlitText(text, textColor, backgroundColor, x, y)
    for i = 1, #text do
        display.drawBlitCharacter(text:sub(i, i), textColor:sub(i, i), backgroundColor:sub(i, i), x + (i - 1), y)
    end
end

function display.drawScreen()
    for i, v in pairs(display.blit) do
        display.drawBlitText(v[1], v[2], v[3], 1, i)
    end
end

function display.drawPlainText(text, x, y)
    display.drawBlitText(text, string.rep("0", text:len()), string.rep("f", text:len()), x, y)
end

return display
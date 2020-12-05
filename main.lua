local scale = 2
local love = _G.love

-- Global variables
_G.termSize = {x = 51, y = 19}
_G.error = function(err)
    print(err)
end

-- Load APIS
local http = require("socket.http")
local display = require("apis.internal.display")

-- Load serviuces
local displaySvc = require("services.display")
local osSvc = require("services.os")

-- Paths
local appdata = love.filesystem.getSaveDirectory()
local computerPath = appdata .. "/computer/0"

-- Window size
local tW, tH = (termSize.x * 6) * scale + 8, (termSize.y * 9) * scale + 8

local thread

local function start()
    thread = love.thread.newThread( "resources/computerThread.lua" )
    thread:start(termSize, termUpdateChannel)
end

function love.load()
    love.window.setMode(tW, tH)
    love.thread.newChannel("term_update")
    _G.osUpdateChannel = love.thread.newChannel("os_update")
    start()
end

function love.update()
    displaySvc.run(display.blit, termUpdateChannel)
    osSvc.run(thread, osUpdateChannel)
end

function love.draw()
    love.graphics.scale(scale, scale)
    display.drawScreen()
end
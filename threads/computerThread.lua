local args = { ... }
_G.termSize = args[1]
_G.termUpdateChannel = args[2]

local ccos = require("apis.system.os")

for i, v in pairs(ccos) do
    _G.os[i] = v
end


for i, v in pairs(_G.os) do
    print(i, v)
end

fs = require("apis.system.fs")
term = require("apis.system.term")
term.setTermUpdateChannel(termUpdateChannel)
bit32 = require("bit")
rs = require("apis.system.rs")

log = print
table.unpack = unpack

do
    love = nil
    termUpdateChannel = nil
    dofile("resources/lua/bios.lua")
end
local args = { ... }
_G.termSize = args[1]
_G.termUpdateChannel = args[1]

fs = require("apis.system.fs")
term = require("apis.system.term")
bit32 = require("bit")
rs = require("apis.system.rs")
os = require("apis.system.os")
log = print
table.unpack = unpack

do
    love = nil
    termUpdateChannel = nil
    dofile("resources/lua/bios.lua")
end
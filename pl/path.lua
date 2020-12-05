-- Only some functions that are used within l2d-ccemu.
local utils = require 'pl.utils'
local assert_arg,assert_string,raise = utils.assert_arg,utils.assert_string,utils.raise
local path = {}
local sub = string.sub
path.sep = '/'

local function at(s,i)
    return sub(s,i,i)
end

function path.splitpath(P)
    assert_string(1,P)
    local i = #P
    local ch = at(P,i)
    while i > 0 and ch ~= sep and ch ~= other_sep do
        i = i - 1
        ch = at(P,i)
    end
    if i == 0 then
        return '',P
    else
        return sub(P,1,i-1), sub(P,i+1)
    end
end

function path.splitext(P)
    assert_string(1,P)
    local i = #P
    local ch = at(P,i)
    while i > 0 and ch ~= '.' do
        if ch == sep or ch == other_sep then
            return P,''
        end
        i = i - 1
        ch = at(P,i)
    end
    if i == 0 then
        return P,''
    else
        return sub(P,1,i-1),sub(P,i)
    end
end

--- return the directory part of a path
-- @string P A file path
function path.dirname(P)
    assert_string(1,P)
    local p1,p2 = path.splitpath(P)
    return p1
end

--- return the file part of a path
-- @string P A file path
function path.basename(P)
    assert_string(1,P)
    local p1,p2 = path.splitpath(P)
    return p2
end

--- get the extension part of a path.
-- @string P A file path
function path.extension(P)
    assert_string(1,P)
    local p1,p2 = path.splitext(P)
    return p2
end

function path.isabs(P)
    assert_string(1,P)
    if path.is_windows then
        return at(P,1) == '/' or at(P,1)=='\\' or at(P,2)==':'
    else
        return at(P,1) == '/'
    end
end

function path.join(p1,p2,...)
    assert_string(1,p1)
    assert_string(2,p2)
    if select('#',...) > 0 then
        local p = path.join(p1,p2)
        local args = {...}
        for i = 1,#args do
            assert_string(i,args[i])
            p = path.join(p,args[i])
        end
        return p
    end
    if path.isabs(p2) then return p2 end
    local endc = at(p1,#p1)
    if endc ~= path.sep and endc ~= other_sep and endc ~= "" then
        p1 = p1..path.sep
    end
    return p1..p2
end

return path
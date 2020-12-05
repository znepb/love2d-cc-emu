local fs = {}
local plpath = require("pl.path")

local function evalPath(path)
    if path:find("^/") then
        path = path:sub(2)
    end

    if path == "" then

    elseif path:find("^rom") then
        return "resources/lua/" .. path, true
    else
        return computerPath .. "/" .. path, false
    end
end

fs.list = function(path)
    return love.filesystem.getDirectoryItems(evalPath(path))
end

fs.combine = function(p1, p2, ...)
    return plpath.join(p1, p2, ...)
end

fs.exists = function(path)
    if love.filesystem.getInfo(path) then
        return true  
    end
    return false
end

fs.getName = function(path)
    print(path:match("^.+/(.+)$"))
    return path:match("^.+/(.+)$")
end

fs.isDir = function(path)
    return love.filesystem.getInfo(evalPath(path)).type == "directory"
end

function fs.open(path, mode)
    local evaluatedPath, isRom = evalPath(path)

    if love.filesystem.getInfo(evaluatedPath).type == "directory" then
        return nil, "Cannot read/write to directory"
    end

    if mode == "r" then
        return {
            readAll = function()
                return love.filesystem.read(evaluatedPath)
            end,
            close = function()
            end
        }
    elseif mode == "w" then
        if isRom then
            return nil, "File is read-only."
        end
    elseif mode == "a" then

    end
end

return fs
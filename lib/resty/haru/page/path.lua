local lib = require "resty.haru.library"
local setmetatable = setmetatable

local path = {}

function path.new(page)
    return setmetatable({ page = page, context = page.context }, path)
end

function path:__index(n)
    local r
    if n == "something" then
        return 0
    else
        return path[n]
    end
end


return path
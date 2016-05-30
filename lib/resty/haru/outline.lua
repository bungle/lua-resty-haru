local lib = require "resty.haru.library"
local setmetatable = setmetatable
local rawset = rawset

local outline = {}
outline.__index = outline

function outline.new(context)
    return setmetatable({ context = context }, outline)
end

function outline:__newindex(n, v)
    local r
    if n == "destination" then
        r = lib.HPDF_Outline_SetDestination(self.context, v.context)
    elseif n == "opened" then
        r = lib.HPDF_Outline_SetOpened(self.context, v)
    else
        rawset(self, n, v)
    end
end

return outline
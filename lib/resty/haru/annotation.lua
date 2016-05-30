local lib = require "resty.haru.library"
local enums = require "resty.haru.enums"
local icon = enums.annotation.icon
local setmetatable = setmetatable
local rawset = rawset
local type = type

local annotation = {}
annotation.__index = annotation

function annotation.new(context)
    return setmetatable({ context = context }, annotation)
end

function annotation:__newindex(n, v)
    if n == "borderstyle" then
    elseif n == "icon" then
        if type(v) == "string" then
            v = icon[v]
        end
        lib.HPDF_TextAnnot_SetIcon(self.context, v)
    elseif n == "opened" then
        lib.HPDF_TextAnnot_SetOpened(self.context, v)
    else
        rawset(self, n, v)
    end
end

return annotation
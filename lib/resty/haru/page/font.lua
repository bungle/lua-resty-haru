local lib = require "resty.haru.library"
local setmetatable = setmetatable

local font = {}
font.__index = font

function font.new(page)
    return setmetatable({ page = page, context = page.context }, font)
end

function font:set(font, size)
    local r = lib.HPDF_Page_SetFontAndSize(self.context, font.context, size)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

return font
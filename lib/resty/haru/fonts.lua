local lib = require "resty.haru.library"
local font = require "resty.haru.font"
local setmetatable = setmetatable

local fonts = {}
fonts.__index = fonts

function fonts.new(document)
    return setmetatable({ document = document, context = document.context }, fonts)
end

function fonts:get(name, encoding)
    return font.new(self.document, lib.HPDF_GetFont(self.context, name, encoding))
end

return fonts
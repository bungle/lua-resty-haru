local ffi          = require "ffi"
local ffi_str      = ffi.string
local lib          = require "resty.haru.library"
local font         = require "resty.haru.font"
local sub          = string.sub
local lower        = string.lower
local setmetatable = setmetatable

local fonts        = {}
fonts.__index      = fonts

function fonts.new(context)
    return setmetatable({ context = context }, fonts)
end

function fonts:get(name, encoding)
    return font.new(lib.HPDF_GetFont(self.context, name, encoding))
end

function fonts:load(file, embed)
    if lower(sub(file, -4)) == '.ttf' then
        return ffi_str(lib.HPDF_LoadTTFontFromFile(self.context, file, embed == true and 1 or 0))
    end
end

return fonts

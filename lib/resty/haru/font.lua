local lib = require "resty.haru.library"
local ffi = require "ffi"
local ffi_str = ffi.string
local setmetatable = setmetatable

local font = {}
font.__index = font

function font.new(context)
    return setmetatable({ context = context }, font)
end

function font:__index(n)
    if n == "name" then
        return ffi_str(lib.HPDF_Font_GetFontName(self.context))
    elseif n == "encoding" then
        return ffi_str(lib.HPDF_Font_GetEncodingName(self.context))
    elseif n == "ascent" then
        return lib.HPDF_Font_GetAscent(self.context)
    elseif n == "descent" then
        return lib.HPDF_Font_GetDescent(self.context)
    elseif n == "descent" then
        return lib.HPDF_Font_GetDescent(self.context)
    elseif n == "xheight" then
        return lib.HPDF_Font_GetXHeight(self.context)
    elseif n == "capheight" then
        return lib.HPDF_Font_GetCapHeight(self.context)
    elseif n == "bbox" then
        local b = lib.HPDF_Font_GetBBox(self.context)
        return {
            left   = b.left,
            bottom = b.bottom,
            right  = b.right,
            top    = b.top
        }
    else
        return font[n]
    end
end

return font
local lib = require "resty.haru.library"
local ffi = require "ffi"
local ffi_str = ffi.string
local setmetatable = setmetatable
local rawset = rawset

local font = {}
font.__index = font

function font.new(document, context)
    local self = setmetatable({ document = document, context = context }, font)
    return self
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
    else
        return font[n]
    end
end

function font:__newindex(n, v)
    rawset(self, n, v)
end

return font
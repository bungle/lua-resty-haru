local ffi = require "ffi"
local lib = require "resty.haru.library"
local ffi_str = ffi.string
local setmetatable = setmetatable

local image = {}

function image.new(document, context)
    return setmetatable({ document = document, context = context }, image)
end

function image:size()
    local size = lib.HPDF_Image_GetSize(self.context)
    return size.x, size.y
end

function image:__index(n)
    local r
    if n == "width" then
        r = lib.HPDF_Image_GetWidth(self.context)
    elseif n == "height" then
        r = lib.HPDF_Image_GetHeight(self.context)
    elseif n == "colorspace" then
        r = lib.HPDF_Image_GetColorSpace(self.context)
        if r then
            r = ffi_str(r)
        end
    elseif n == "bitspercomponent" then
        r = lib.HPDF_Image_GetBitsPerComponent(self.context)
    else
        return image[n]
    end
    if r == 0 then
        return nil
    else
        return r
    end
end

--[[
function image:__newindex(n, v)
    if n == "width" then
        lib.HPDF_Page_SetWidth(self.context, v)
    elseif n == "height" then
        lib.HPDF_Page_SetHeight(self.context, v)
    else
        rawset(self, n, v)
    end
end
--]]

return image
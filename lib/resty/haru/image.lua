local ffi = require "ffi"
local lib = require "resty.haru.library"
local ffi_str = ffi.string
local setmetatable = setmetatable
local rawset = rawset
local type = type

local image = {}

function image.new(context)
    return setmetatable({ context = context }, image)
end

function image:__index(n)
    local r
    if n == "width" then
        r = lib.HPDF_Image_GetWidth(self.context)
    elseif n == "height" then
        r = lib.HPDF_Image_GetHeight(self.context)
    elseif n == "size" then
        local size = lib.HPDF_Image_GetSize(self.context)
        return { x = size.x, y = size.y }
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

function image:__newindex(n, v)
    local r
    if n == "colormask" then
        local rmin, rmax, gmin, gmax, bmin, bmax = 0, 0, 0, 0, 0, 0
        if (type(v) == "table") then
            rmin = v.rmin or v[1] or 0
            rmax = v.rmax or v[2] or 0
            gmin = v.gmin or v[3] or 0
            gmax = v.gmax or v[4] or 0
            bmin = v.bmin or v[5] or 0
            bmax = v.bmax or v[6] or 0
        end
        r = lib.HPDF_Image_SetColorMask(self.context, rmin, rmax, gmin, gmax, bmin, bmax)
    else
        rawset(self, n, v)
    end
end


return image
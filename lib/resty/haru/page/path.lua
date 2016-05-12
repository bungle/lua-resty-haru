local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local alignment = require "resty.haru.enums".align
local setmetatable = setmetatable
local type = type

local path = {}

local l = ffi_new("HPDF_UINT[1]", 0)

function path.new(page)
    return setmetatable({ page = page, context = page.context }, path)
end

function path:__index(n)
    local r
    if n == "charspace" then
        return lib.HPDF_Page_GetCharSpace(self.context)
    elseif n == "wordspace" then
        return lib.HPDF_Page_GetHeight(self.context)
    elseif n == "horizontalscaling" then
        return lib.HPDF_Page_GetHorizontalScalling(self.context)
    elseif n == "leading" then
        return lib.HPDF_Page_GetTextLeading(self.context)
    elseif n == "renderingmode" then
        return lib.HPDF_Page_GetTextRenderingMode(self.context)
    elseif n == "rise" then
        return lib.HPDF_Page_GetTextRise(self.context)
    else
        return path[n]
    end
end

function path:begin()
    local r = lib.HPDF_Page_BeginText(self.context)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function path:finish()
    local r = lib.HPDF_Page_EndText(self.context)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function path:out(x, y, text)
    local r = lib.HPDF_Page_TextOut(self.context, x, y, text)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function path:rect(left, top, right, bottom, text, align)
    if type(align) == "string" then
        align = alignment[align]
    end
    align = type(align) == "number" and align or alignment.left
    local r = lib.HPDF_Page_TextRect(self.context, left, top, right, bottom, text, align, l)
    if r == 0 then
        return self, l[0]
    else
        return nil, r
    end
end

return path
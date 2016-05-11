local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local alignment = require "resty.haru.enums".align
local setmetatable = setmetatable
local type = type

local text = {}
text.__index = text

local l = ffi_new("HPDF_UINT[1]", 0)

function text.new(page)
    return setmetatable({ page = page, context = page.context }, text)
end

function text:begin()
    local r = lib.HPDF_Page_BeginText(self.context)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function text:finish()
    local r = lib.HPDF_Page_EndText(self.context)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function text:out(x, y, text)
    local r = lib.HPDF_Page_TextOut(self.context, x, y, text)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function text:rect(left, top, right, bottom, text, align)
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

return text
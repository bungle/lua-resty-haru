local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local alignment = require "resty.haru.enums".align
local setmetatable = setmetatable
local type = type

local text = {}

local l = ffi_new("HPDF_UINT[1]", 0)

function text.new(page)
    return setmetatable({ page = page, context = page.context }, text)
end

function text:__index(n)
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
        return text[n]
    end
end

function text:begin()
    local r = lib.HPDF_Page_BeginText(self.context)
    return r ~= 0 and r or nil
end

function text:finish()
    local r = lib.HPDF_Page_EndText(self.context)
    return r ~= 0 and r or nil
end

function text:show(text, ws, cs)
    local r
    if type(ws) == "number" and type(cs) == "number" then
        r = lib.HPDF_Page_ShowTextNextLineEx(self.context, ws, cs, text)
    elseif ws then
        r = lib.HPDF_Page_ShowTextNextLine(self.context, text)
    else
        r = lib.HPDF_Page_ShowText(self.context, text)
    end
    return r ~= 0 and r or nil
end

function text:pos(x, y)
    local r = lib.HPDF_Page_MoveTextPos(self.context, x, y)
    return r ~= 0 and r or nil
end

function text:out(x, y, text)
    local r = lib.HPDF_Page_TextOut(self.context, x, y, text)
    return r ~= 0 and r or nil
end

function text:rect(left, top, right, bottom, text, align)
    if type(align) == "string" then
        align = alignment[align]
    end
    align = type(align) == "number" and align or alignment.left
    local r = lib.HPDF_Page_TextRect(self.context, left, top, right, bottom, text, align, l)
    return r ~= 0 and r or nil
end

return text
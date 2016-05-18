local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local alignment = require "resty.haru.enums".align
local setmetatable = setmetatable
local rawset = rawset
local type = type

local l = ffi_new("HPDF_UINT[1]", 0)

local page = {}

function page.new(document, context)
    return setmetatable({ document = document, context = context }, page)
end

function page:move(x, y)
    local r = lib.HPDF_Page_MoveTo(self.context, x, y)
    return r ~= 0 and r or nil
end

function page:circle(x, y, r)
    local r = lib.HPDF_Page_Circle(self.context, x, y, r)
    return r ~= 0 and r or nil
end

function page:rectangle(x, y, w, h)
    local r = lib.HPDF_Page_Rectangle(self.context, x, y, w, h)
    return r ~= 0 and r or nil
end

function page:arc(x, y, r, a1, a2)
    local r = lib.HPDF_Page_Arc(self.context, x, y, r, a1, a2)
    return r ~= 0 and r or nil
end

function page:ellipse(x, y, xr, yr)
    local r = lib.HPDF_Page_Ellipse(self.context, x, y, xr, yr)
    return r ~= 0 and r or nil
end

function page:line(x, y)
    local r = lib.HPDF_Page_LineTo(self.context, x, y)
    return r ~= 0 and r or nil
end

function page:stroke()
    local r = lib.HPDF_Page_Stroke(self.context)
    return r ~= 0 and r or nil
end

function page:textbegin()
    local r = lib.HPDF_Page_BeginText(self.context)
    return r ~= 0 and r or nil
end

function page:textend()
    local r = lib.HPDF_Page_EndText(self.context)
    return r ~= 0 and r or nil
end

function page:text(p1, p2, p3, p4, p5, p6)
    local tp1, tp2, tp3, tp4 = type(p1), type(p2), type(p3), type(p4)
    if tp1 == "number" and tp2 == "number" and tp3 == "number" and tp4 == "number" then
        return self:textrect(p1, p2, p3, p4, p5, p6)
    elseif tp1 == "number" and tp2 == "number" then
        return self:textout(p1, p2, p3)
    else
        return self:textshow(p1, p2, p3)
    end
end

function page:textshow(text, ws, cs)
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

function page:textrect(left, top, right, bottom, text, align)
    if type(align) == "string" then
        align = alignment[align]
    end
    align = type(align) == "number" and align or alignment.left
    local r = lib.HPDF_Page_TextRect(self.context, left, top, right, bottom, text, align, l)
    return r ~= 0 and r or nil
end

function page:textout(x, y, text)
    local r = lib.HPDF_Page_TextOut(self.context, x, y, text)
    return r ~= 0 and r or nil
end

function page:textmove(x, y)
    local r = lib.HPDF_Page_MoveTextPos(self.context, x, y)
    return r ~= 0 and r or nil
end

function page:image(image, x, y, w, h)
    w = w or image.width
    h = h or image.height
    lib.HPDF_Page_DrawImage(self.context, image.context, x, y, w, h)
end

function page:font(font, size)
    local r = lib.HPDF_Page_SetFontAndSize(self.context, font.context, size)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function page:__index(n)
    local r
    if n == "width" then
        r = lib.HPDF_Page_GetWidth(self.context)
    elseif n == "height" then
        r = lib.HPDF_Page_GetHeight(self.context)
    elseif n == "grayfill" then
        return lib.HPDF_Page_GetGrayFill(self.context)
    elseif n == "graystroke" then
        return lib.HPDF_Page_GetGrayStroke(self.context)
    elseif n == "charspace" then
        return lib.HPDF_Page_GetCharSpace(self.context)
    elseif n == "wordspace" then
        return lib.HPDF_Page_GetWordSpace(self.context)
    elseif n == "horizontalscaling" then
        return lib.HPDF_Page_GetHorizontalScalling(self.context)
    elseif n == "textleading" then
        return lib.HPDF_Page_GetTextLeading(self.context)
    elseif n == "textrenderingmode" then
        return lib.HPDF_Page_GetTextRenderingMode(self.context)
    elseif n == "textrise" then
        return lib.HPDF_Page_GetTextRise(self.context)
    else
        return page[n]
    end
    if r == 0 then
        return nil
    else
        return r
    end
end

function page:__newindex(n, v)
    if n == "width" then
        lib.HPDF_Page_SetWidth(self.context, v)
    elseif n == "height" then
        lib.HPDF_Page_SetHeight(self.context, v)
    else
        rawset(self, n, v)
    end
end

return page
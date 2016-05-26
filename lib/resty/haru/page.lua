local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local enums = require "resty.haru.enums"
local renderingmode = enums.textrenderingmode
local alignment = enums.align
local pagesize = enums.pagesize
local pagedirection = enums.pagedirection
local setmetatable = setmetatable
local rawset = rawset
local type = type

local l = ffi_new("HPDF_UINT[1]", 0)

local page = {}

function page.new(document, context)
    return setmetatable({ document = document, context = context }, page)
end

function page:gsave()
    local r = lib.HPDF_Page_GSave(self.context)
    return r ~= 0 and r or nil
end

function page:grestore()
    local r = lib.HPDF_Page_GRestore(self.context)
    return r ~= 0 and r or nil
end

function page:ln()
    local r = lib.HPDF_Page_MoveToNextLine(self.context)
    return r ~= 0 and r or nil
end

function page:move(x, y)
    local r = lib.HPDF_Page_MoveTo(self.context, x, y)
    return r ~= 0 and r or nil
end

function page:pos()
    local pos = lib.HPDF_Page_GetCurrentPos(self.context)
    return pos.x, pos.y
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

function page:begintext()
    local r = lib.HPDF_Page_BeginText(self.context)
    return r ~= 0 and r or nil
end

function page:endtext()
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

function page:textwidth(text)
    local r = lib.HPDF_Page_TextWidth(self.context, text)
    return r ~= 0 and r or nil
end

function page:textpos()
    local pos = lib.HPDF_Page_GetCurrentTextPos(self.context)
    return pos.x, pos.y
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

function page:size(size, direction)
    if type(size) == "string" then
        size = pagesize[size]
    end
    if type(direction) == "string" then
        direction = pagedirection[direction]
    end
    local r = lib.HPDF_Page_SetSize(self.context, size, direction)
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
    elseif n == "textrise" then
        return lib.HPDF_Page_GetTextRise(self.context)
    elseif n == "textrenderingmode" then
        return lib.HPDF_Page_GetTextRenderingMode(self.context)
    elseif n == "fontsize" then
        return lib.HPDF_Page_GetCurrentFontSize(self.context);
    elseif n == "linewidth" then
        return lib.HPDF_Page_GetLineWidth(self.context);
    elseif n == "miterlimit" then
        return lib.HPDF_Page_GetMiterLimit(self.context);
    elseif n == "flatness" then
        return lib.HPDF_Page_GetFlat(self.context);
    elseif n == "gmode" then
        return lib.HPDF_Page_GetGMode(self.context);
    elseif n == "gdepth" then
        return lib.HPDF_Page_GetGStateDepth(self.context);
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
    local r
    if n == "width" then
        r = lib.HPDF_Page_SetWidth(self.context, v)
    elseif n == "height" then
        r = lib.HPDF_Page_SetHeight(self.context, v)
    elseif n == "grayfill" then
        r = lib.HPDF_Page_SetGrayFill(self.context, v)
    elseif n == "graystroke" then
        r = lib.HPDF_Page_SetGrayStroke(self.context, v)
    elseif n == "charspace" then
        r = lib.HPDF_Page_SetCharSpace(self.context, v)
    elseif n == "wordspace" then
        r = lib.HPDF_Page_SetWordSpace(self.context, v)
    elseif n == "horizontalscaling" then
        r = lib.HPDF_Page_SetHorizontalScalling(self.context, v)
    elseif n == "textleading" then
        r = lib.HPDF_Page_SetTextLeading(self.context, v)
    elseif n == "textrise" then
        r = lib.HPDF_Page_SetTextRise(self.context, v)
    elseif n == "textrenderingmode" then
        if type(v) == "string" then
            v = alignment[v]
        end
        r = lib.HPDF_Page_SetTextRenderingMode(self.context, type(v) == "number" and v or renderingmode.fill)
    else
        rawset(self, n, v)
    end
end

return page
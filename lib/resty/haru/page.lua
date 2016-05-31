local ffi = require "ffi"
local ffi_new = ffi.new
local lib = require "resty.haru.library"
local enums = require "resty.haru.enums"
local fnt = require "resty.haru.font"
local destination = require "resty.haru.destination"
local annotation = require "resty.haru.annotation"
local renderingmode = enums.textrenderingmode
local alignment = enums.align
local pagesize = enums.pagesize
local pagedirection = enums.pagedirection
local linecap = enums.linecap
local linejoin = enums.linejoin
local setmetatable = setmetatable
local rawset = rawset
local type = type
local tonumber = tonumber

local l = ffi_new("HPDF_UINT[1]", 0)
local rect = ffi_new "HPDF_Rect"
local dash = ffi_new("HPDF_UINT16[8]", 0)
local page = {}

function page.new(context)
    return setmetatable({ context = context }, page)
end

function page:gsave()
    local r = lib.HPDF_Page_GSave(self.context)
    return r ~= 0 and r or nil
end

function page:grestore()
    local r = lib.HPDF_Page_GRestore(self.context)
    return r ~= 0 and r or nil
end

function page:clip()
    local r = lib.HPDF_Page_Clip(self.context)
    return r ~= 0 and r or nil
end

function page:eoclip()
    local r = lib.HPDF_Page_Eoclip(self.context)
    return r ~= 0 and r or nil
end

function page:fill()
    local r = lib.HPDF_Page_Fill(self.context)
    return r ~= 0 and r or nil
end

function page:fillstroke()
    local r = lib.HPDF_Page_FillStroke(self.context)
    return r ~= 0 and r or nil
end

function page:eofill()
    local r = lib.HPDF_Page_Eofill(self.context)
    return r ~= 0 and r or nil
end

function page:eofillstroke()
    local r = lib.HPDF_Page_EofillStroke(self.context)
    return r ~= 0 and r or nil
end

function page:closepath()
    local r = lib.HPDF_Page_ClosePath(self.context)
    return r ~= 0 and r or nil
end

function page:closepathstroke()
    local r = lib.HPDF_Page_ClosePathStroke(self.context)
    return r ~= 0 and r or nil
end

function page:closepathfillstroke()
    local r = lib.HPDF_Page_ClosePathFillStroke(self.context)
    return r ~= 0 and r or nil
end

function page:closepatheofillstroke()
    local r = lib.HPDF_Page_ClosePathEofillStroke(self.context)
    return r ~= 0 and r or nil
end

function page:endpath()
    local r = lib.HPDF_Page_EndPath(self.context)
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

function page:curve(x1, y1, x2, y2, x3, y3)
    local r = lib.HPDF_Page_CurveTo(self.context, x1, y1, x2, y2, x3, y3)
    return r ~= 0 and r or nil
end

function page:stroke()
    local r = lib.HPDF_Page_Stroke(self.context)
    return r ~= 0 and r or nil
end

function page:concat(a, b, c, d, x, y)
    local r = lib.HPDF_Page_Concat(self.context, a, b, c, d, x, y)
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
    if font == nil then
        return fnt.new(lib.HPDF_Page_GetCurrentFont(self.context))
    else
        local r = lib.HPDF_Page_SetFontAndSize(self.context, font.context, size)
        if r == 0 then
            return self
        else
            return nil, r
        end
    end
end

function page:destination()
    return destination.new(lib.HPDF_Page_CreateDestination(self.context))
end

function page:textannotation(left, bottom, right, top, text, encoder)
    rect.left   = left   or 0
    rect.bottom = bottom or 0
    rect.right  = right  or 0
    rect.top    = top    or 0
    return annotation.new(lib.HPDF_Page_CreateTextAnnot(self.context, rect, text, encoder))
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
    elseif n == "linecap" then
        return tonumber(lib.HPDF_Page_GetLineCap(self.context));
    elseif n == "linejoin" then
        return tonumber(lib.HPDF_Page_GetLineJoin(self.context));
    elseif n == "flatness" then
        return lib.HPDF_Page_GetFlat(self.context);
    elseif n == "gmode" then
        return lib.HPDF_Page_GetGMode(self.context);
    elseif n == "gdepth" then
        return lib.HPDF_Page_GetGStateDepth(self.context);
    elseif n == "strokingcolorspace" then
        return tonumber(lib.HPDF_Page_GetStrokingColorSpace(self.context));
    elseif n == "fillingcolorspace" then
        return tonumber(lib.HPDF_Page_GetFillingColorSpace(self.context));
    elseif n == "rgbstroke" then
        -- TODO: needs to release memory?
        local c = lib.HPDF_Page_GetRGBStroke(self.context)
        return {
            r = c.r,
            g = c.g,
            b = c.b
        }
    elseif n == "rgbfill" then
        -- TODO: needs to release memory?
        local c = lib.HPDF_Page_GetRGBFill(self.context)
        return {
            r = c.r,
            g = c.g,
            b = c.b
        }
    elseif n == "cmykstroke" then
        -- TODO: needs to release memory?
        local c = lib.HPDF_Page_GetCMYKStroke(self.context)
        return {
            c = c.c,
            m = c.m,
            y = c.y,
            k = c.k
        }
    elseif n == "cmykfill" then
        -- TODO: needs to release memory?
        local c = lib.HPDF_Page_GetCMYKFill(self.context)
        return {
            c = c.c,
            m = c.m,
            y = c.y,
            k = c.k
        }
    elseif n == "textmatrix" then
        local m = lib.HPDF_Page_GetTextMatrix(self.context)
        return {
            a = m.a,
            b = m.b,
            c = m.c,
            d = m.d,
            x = m.x,
            y = m.y
        }
    elseif n == "transmatrix" then
        local m = lib.HPDF_Page_GetTransMatrix(self.context)
        return {
            a = m.a,
            b = m.b,
            c = m.c,
            d = m.d,
            x = m.x,
            y = m.y
        }
    elseif n == "dash" then
        local d = lib.HPDF_Page_GetDash(self.context)
        local ptn = d.ptn
        return {
            dash  = { ptn[0], ptn[1], ptn[2], ptn[3], ptn[4], ptn[5], ptn[6], ptn[7] },
            n     = d.num_ptn,
            phase = d.phase
        }
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
            v = renderingmode[v]
        end
        r = lib.HPDF_Page_SetTextRenderingMode(self.context, type(v) == "number" and v or renderingmode.fill)
    elseif n == "linewidth" then
        r = lib.HPDF_Page_SetLineWidth(self.context, v)
    elseif n == "miterlimit" then
        r = lib.HPDF_Page_SetMiterLimit(self.context, v)
    elseif n == "linecap" then
        if type(v) == "string" then
            v = linecap[v]
        end
        lib.HPDF_Page_SetLineCap(self.context, v)
    elseif n == "linejoin" then
        if type(v) == "string" then
            v = linejoin[v]
        end
        lib.HPDF_Page_SetLineJoin(self.context, v)
    elseif n == "rgbstroke" then
        local r, g, b = 0, 0, 0
        if (type(v) == "table") then
            r = v.r or v[1] or 0
            g = v.g or v[2] or 0
            b = v.b or v[3] or 0
        end
        r = lib.HPDF_Page_SetRGBStroke(self.context, r, g, b)
    elseif n == "rgbfill" then
        local r, g, b = 0, 0, 0
        if (type(v) == "table") then
            r = v.r or v[1] or 0
            g = v.g or v[2] or 0
            b = v.b or v[3] or 0
        end
        r = lib.HPDF_Page_SetRGBFill(self.context, r, g, b)
    elseif n == "cmykstroke" then
        local c, m, y, k = 0, 0, 0, 0
        if (type(v) == "table") then
            c = v.c or v[1] or 0
            m = v.m or v[2] or 0
            y = v.y or v[3] or 0
            k = v.k or v[4] or 0
        end
        r = lib.HPDF_Page_SetCMYKStroke(self.context, c, m, y, k)
    elseif n == "cmykfill" then
        local c, m, y, k = 0, 0, 0, 0
        if (type(v) == "table") then
            c = v.c or v[1] or 0
            m = v.m or v[2] or 0
            y = v.y or v[3] or 0
            k = v.k or v[4] or 0
        end
        r = lib.HPDF_Page_SetCMYKStroke(self.context, c, m, y, k)
    elseif n == "textmatrix" then
        local a, b, c, d, x, y = 0, 0, 0, 0, 0, 0
        if (type(v) == "table") then
            a = v.a or v[1] or 0
            b = v.b or v[2] or 0
            c = v.c or v[3] or 0
            d = v.d or v[4] or 0
            x = v.x or v[5] or 0
            y = v.y or v[6] or 0
        end
        r = lib.HPDF_Page_SetTextMatrix(self.context, a, b, c, d, x, y)
    elseif n == "dash" then
        if type(v) == "table" then
            local d = v.dash
            local s = v.n
            local p = v.phase or 0
            if not s then
                s = type(d) == "table" and #d or 0
            end
            for i=1, s do
                dash[i-1] = d[i] or 0
            end
            r = lib.HPDF_Page_SetDash(self.context, dash, s, p);
        elseif v == nil then
            r = lib.HPDF_Page_SetDash(self.context, nil, 0, 0);
        end
    else
        rawset(self, n, v)
    end
end

return page
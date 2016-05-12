local lib = require "resty.haru.library"
local text = require "resty.haru.page.text"
local path = require "resty.haru.page.path"
local font = require "resty.haru.page.font"
local image = require "resty.haru.page.image"
local setmetatable = setmetatable
local rawset = rawset

local page = {}

function page.new(document, context)
    local self = setmetatable({ document = document, context = context }, page)
    self.text = text.new(self)
    self.path = path.new(self)
    self.font = font.new(self)
    self.image = image.new(self)
    return self
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

function page:stroke()
    local r = lib.HPDF_Page_Stroke(self.context)
    return r ~= 0 and r or nil
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
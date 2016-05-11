local lib = require "resty.haru.library"
local text = require "resty.haru.page.text"
local font = require "resty.haru.page.font"
local image = require "resty.haru.page.image"
local setmetatable = setmetatable
local rawset = rawset

local page = {}

function page.new(document, context)
    local self = setmetatable({ document = document, context = context }, page)
    self.text = text.new(self)
    self.font = font.new(self)
    self.image = image.new(self)
    return self
end

function page:__index(n)
    local r
    if n == "width" then
        r = lib.HPDF_Page_GetWidth(self.context)
    elseif n == "height" then
        r = lib.HPDF_Page_GetHeight(self.context)
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
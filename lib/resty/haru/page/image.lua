local lib = require "resty.haru.library"
local setmetatable = setmetatable

local image = {}
image.__index = image

function image.new(page)
    return setmetatable({ page = page, context = page.context }, image)
end

function image:draw(image, x, y, w, h)
    w = w or image.width
    h = h or image.height
    lib.HPDF_Page_DrawImage(self.context, image.context, x, y, w, h)
end

return image
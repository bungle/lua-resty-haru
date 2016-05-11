local lib = require "resty.haru.library"
local image = require "resty.haru.image"
local sub = string.sub
local lower = string.lower
local setmetatable = setmetatable

local images = {}
images.__index = images

function images.new(document)
    return setmetatable({ document = document, context = document.context }, images)
end

function images:load(file)
    local context
    local ext = lower(sub(file, -4))
    if ext == '.png' then
        context = lib.HPDF_LoadPngImageFromFile(self.context, file)
    elseif ext == ".jpg" then
        context = lib.HPDF_LoadJpegImageFromFile(self.context, file)
    end
    if context == nil then return nil end
    return image.new(self.document, context)
end

return images
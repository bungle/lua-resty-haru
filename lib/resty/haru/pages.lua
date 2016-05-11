local lib = require "resty.haru.library"
local page = require "resty.haru.page"
local setmetatable = setmetatable

local pages = {}
pages.__index = pages

function pages.new(document)
    return setmetatable({ document = document, context = document.context }, pages)
end

function pages:add()
    return page.new(self.document, lib.HPDF_AddPage(self.context))
end

return pages
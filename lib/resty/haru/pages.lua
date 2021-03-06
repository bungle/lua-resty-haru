local lib          = require "resty.haru.library"
local page         = require "resty.haru.page"
local setmetatable = setmetatable

local pages        = {}

function pages.new(context)
    return setmetatable({ context = context }, pages)
end

function pages:__index(n)
    if n == "current" then
        local p = lib.HPDF_GetCurrentPage(self.context)
        if p == nil then
            return nil
        end
        return page.new(p)
    else
        return pages[n]
    end
end

function pages:add()
    return page.new(lib.HPDF_AddPage(self.context))
end

function pages:insert(page)
    return page.new(lib.HPDF_InsertPage(self.context, page.context))
end

return pages

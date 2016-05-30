local lib = require "resty.haru.library"
local encoder = require "resty.haru.encoder"
local setmetatable = setmetatable
local rawset = rawset

local encoders = {}

function encoders.new(context)
    return setmetatable({ context = context }, encoders)
end

function encoders:__index(n)
    if n == "current" then
        local e = lib.HPDF_GetCurrentEncoder(self.context)
        if e == nil then
            return nil
        end
        return encoder.new(self.context, e)
    else
        return encoders[n]
    end
end

function encoders:__newindex(n, v)
    local r
    if n == "current" then
        r = lib.HPDF_SetCurrentEncoder(self.context, v)
    else
        rawset(self, n, v)
    end
end

function encoders:get(encoding)
    local e = lib.HPDF_GetEncoder(self.context, encoding)
    if e == nil then
        return nil
    end
    return encoder.new(self.context, e)
end

return encoders
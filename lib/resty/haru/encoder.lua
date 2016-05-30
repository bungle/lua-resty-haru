local lib = require "resty.haru.library"
local setmetatable = setmetatable
local tonumber = tonumber

local encoder = {}
encoder.__index = encoder

function encoder.new(context)
    return setmetatable({ context = context }, encoder)
end

function encoder:__index(n)
    if n == "type" then
        return tonumber(lib.HPDF_Encoder_GetType(self.context))
    elseif n == "writingmode" then
        return tonumber(lib.HPDF_Encoder_GetWritingMode(self.context))
    else
        return encoder[n]
    end
end

return encoder
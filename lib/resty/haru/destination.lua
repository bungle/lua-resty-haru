local lib           = require "resty.haru.library"
local setmetatable  = setmetatable
local rawset        = rawset

local destination   = {}
destination.__index = destination

function destination.new(context)
    return setmetatable({ context = context }, destination)
end

function destination:fit()
    local r = lib.HPDF_Destination_SetFit(self.context)
    return r ~= 0 and r or nil
end

function destination:fitb()
    local r = lib.HPDF_Destination_SetFitB(self.context)
    return r ~= 0 and r or nil
end

function destination:fith(top)
    local r = lib.HPDF_Destination_SetFitH(self.context, top)
    return r ~= 0 and r or nil
end

function destination:fitbh(top)
    local r = lib.HPDF_Destination_SetFitBH(self.context, top)
    return r ~= 0 and r or nil
end

function destination:fitbv(top)
    local r = lib.HPDF_Destination_SetFitBV(self.context, top)
    return r ~= 0 and r or nil
end

function destination:fitv(left)
    local r = lib.HPDF_Destination_SetFitV(self.context, left)
    return r ~= 0 and r or nil
end

function destination:fitr(left, bottom, right, top)
    local r = lib.HPDF_Destination_SetFitR(self.context, left, bottom, right, top)
    return r ~= 0 and r or nil
end

function destination:__newindex(n, v)
    if n == "xyz" then
        lib.HPDF_Destination_SetXYZ(self.context, v.left or v[1] or 0, v.top or v[2] or 0, v.zoom or v[2] or 0)
    else
        rawset(self, n, v)
    end
end

return destination

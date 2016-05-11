local lib = require "resty.haru.library"
local pages = require "resty.haru.pages"
local fonts = require "resty.haru.fonts"
local images = require "resty.haru.images"
local ffi = require "ffi"
local ffi_gc = ffi.gc
local setmetatable = setmetatable
local lower = string.lower

local haru = {}
haru.__index = haru

function haru.new()
    local self = setmetatable({ context = ffi_gc(lib.HPDF_New(nil, nil), lib.HPDF_Free) }, haru)
    self.pages = pages.new(self)
    self.fonts = fonts.new(self)
    self.images = images.new(self)
    return self
end

function haru:use(option)
    option = lower(option)
    local r
    if     option == "jpencodings"  then
        r = lib.HPDF_UseJPEncodings(self.context)
    elseif option == "krencodings"  then
        r = lib.HPDF_UseKREncodings(self.context)
    elseif option == "cnsencodings" then
        r = lib.HPDF_UseCNSEncodings(self.context)
    elseif option == "cntencodings" then
        r = lib.HPDF_UseCNTEncodings(self.context)
    elseif option == "utfencodings" then
        r = lib.HPDF_UseUTFEncodings(self.context)
    elseif option == "jpfonts"      then
        r = lib.HPDF_UseJPFonts(self.context)
    elseif option == "krfonts"      then
        r = lib.HPDF_UseKRFonts(self.context)
    elseif option == "cnsfonts"     then
        r = lib.HPDF_UseCNSFonts(self.context)
    elseif option == "cntfonts"     then
        r = lib.HPDF_UseCNTFonts(self.context)
    end
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function haru:save(file)
    local r = lib.HPDF_SaveToFile(self.context, file)
    if r == 0 then
        return self
    else
        return nil, r
    end
end

return haru
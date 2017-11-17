local lib             = require "resty.haru.library"
local pages           = require "resty.haru.pages"
local fonts           = require "resty.haru.fonts"
local images          = require "resty.haru.images"
local encoders        = require "resty.haru.encoders"
local outline         = require "resty.haru.outline"
local enums           = require "resty.haru.enums"
local pagelayout      = enums.pagelayout
local pagemode        = enums.pagemode
local compressionmode = enums.compressionmode
local encryptionmode  = enums.encryptionmode
local permission      = enums.permission
local infotype        = enums.infotype
local numberstyle     = enums.numberstyle
local ffi             = require "ffi"
local ffi_gc          = ffi.gc
local ffi_str         = ffi.string
local ffi_new         = ffi.new
local setmetatable    = setmetatable
local lower           = string.lower
local byte            = string.byte
local rawset          = rawset
local tonumber        = tonumber
local type            = type

local date            = ffi_new "HPDF_Date"
local haru            = {}

function haru.new()
    local self = setmetatable({ context = ffi_gc(lib.HPDF_New(nil, nil), lib.HPDF_Free) }, haru)
    self.pages = pages.new(self.context)
    self.fonts = fonts.new(self.context)
    self.images = images.new(self.context)
    self.encoders = encoders.new(self.context)
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

function haru:outline(parent, title, encoder)
    return outline.new(lib.HPDF_CreateOutline(self.context, parent, title, type(encoder) == "table" and encoder.context or nil))
end

function haru:pagelabel(page, style, first, prefix)
    if type(style) == "string" then
        style = numberstyle[style]
    end
    local r = lib.HPDF_AddPageLabel(self.context, page or 0, style or numberstyle.decimal, first or 1, prefix or "");
    if r == 0 then
        return self
    else
        return nil, r
    end
end

function haru:__index(n)
    if n == "encoder" then
        return self.encoders.current
    elseif n == "pagelayout" then
        return tonumber(lib.HPDF_GetPageLayout(self.context))
    elseif n == "pagemode" then
        return tonumber(lib.HPDF_GetPageMode(self.context))
    elseif infotype[n] then
        return ffi_str(lib.HPDF_GetInfoAttr(self.context, infotype[n]))
    else
        return haru[n]
    end
end

function haru:__newindex(n, v)
    if n == "encoding" then
        self.encoders.current = v
    elseif n == "pagelayout" then
        if type(v) == "string" then
            v = pagelayout[v]
        end
        lib.HPDF_SetPageLayout(self.context, v)
    elseif n == "pagemode" then
        if type(v) == "string" then
            v = pagemode[v]
        end
        lib.HPDF_SetPageMode(self.context, v)
    elseif n == "permission" then
        if type(v) == "string" then
            v = permission[v]
        end
        lib.HPDF_SetPermission(self.context, v)
    elseif infotype[n] then
        if (type(v) == "table") then
            date.year        = v.year        or v[1] or 0
            date.month       = v.month       or v[2] or 0
            date.day         = v.day         or v[3] or 0
            date.hour        = v.hour        or v[4] or 0
            date.minutes     = v.minutes     or v[5] or 0
            date.seconds     = v.seconds     or v[6] or 0
            date.ind         = byte(v.ind    or v[7] or " ")
            date.off_hour    = v.off_hour    or v[8] or 0
            date.off_minutes = v.off_minutes or v[9] or 0
            lib.HPDF_SetInfoDateAttr(self.context, infotype[n], date)
        else
            lib.HPDF_SetInfoAttr(self.context, infotype[n], v)
        end
    elseif n == "compression" then
        if type(v) == "string" then
            v = compressionmode[v]
        end
        lib.HPDF_SetCompressionMode(self.context, v)
    elseif n == "encryption" then
        if type(v) == "string" then
            v = encryptionmode[v]
        end
        v = v or encryptionmode.R3
        lib.HPDF_SetEncryptionMode(self.context, v, v == encryptionmode.R3 and 16 or 5)
    elseif n == "password" then
        if type(v) == "table" then
            lib.HPDF_SetPassword(self.context, v.owner or v[1], v.user or v[2])
        else
            lib.HPDF_SetPassword(self.context, v, v)
        end
    else
        rawset(self, n, v)
    end
end
return haru

local lib = require "resty.haru.library"

return {
    align = {
        left    = lib.HPDF_TALIGN_LEFT,
        right   = lib.HPDF_TALIGN_RIGHT,
        center  = lib.HPDF_TALIGN_CENTER,
        justify = lib.HPDF_TALIGN_JUSTIFY
    }
}
local lib = require "resty.haru.library"

return {
    align = {
        left               = lib.HPDF_TALIGN_LEFT,
        right              = lib.HPDF_TALIGN_RIGHT,
        center             = lib.HPDF_TALIGN_CENTER,
        justify            = lib.HPDF_TALIGN_JUSTIFY
    },
    textrenderingmode = {
        fill               = lib.HPDF_FILL,
        stroke             = lib.HPDF_STROKE,
        fillstroke         = lib.HPDF_FILL_THEN_STROKE,
        invisible          = lib.HPDF_INVISIBLE,
        fillclipping       = lib.HPDF_FILL_CLIPPING,
        stokeclipping      = lib.HPDF_STROKE_CLIPPING,
        fillstrokeclipping = lib.HPDF_FILL_STROKE_CLIPPING,
        clipping           = lib.HPDF_CLIPPING,
        eof                = lib.HPDF_RENDERING_MODE_EOF
    }
}
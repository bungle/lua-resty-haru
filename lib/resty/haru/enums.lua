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
    },
    writingmode = {
        horizontal         = lib.HPDF_WMODE_HORIZONTAL,
        vertical           = lib.HPDF_WMODE_VERTICAL,
        eof                = lib.HPDF_WMODE_EOF
    },
    pagelayout = {
        single             = lib.HPDF_PAGE_LAYOUT_SINGLE,
        onecolumn          = lib.HPDF_PAGE_LAYOUT_ONE_COLUMN,
        twocolumnleft      = lib.HPDF_PAGE_LAYOUT_TWO_COLUMN_LEFT,
        twocolumnright     = lib.HPDF_PAGE_LAYOUT_TWO_COLUMN_RIGHT,
        twopageleft        = lib.HPDF_PAGE_LAYOUT_TWO_PAGE_LEFT,
        twopageright       = lib.HPDF_PAGE_LAYOUT_TWO_PAGE_RIGHT,
        eof                = lib.HPDF_PAGE_LAYOUT_EOF
    },
    pagemode = {
        none               = lib.HPDF_PAGE_MODE_USE_NONE,
        outline            = lib.HPDF_PAGE_MODE_USE_OUTLINE,
        thumbs             = lib.HPDF_PAGE_MODE_USE_THUMBS,
        fullscreen         = lib.HPDF_PAGE_MODE_FULL_SCREEN,
        eof                = lib.HPDF_PAGE_MODE_EOF
    },
    infotype = {
        creationdate       =  lib.HPDF_INFO_CREATION_DATE,
        modificationdate   = lib.HPDF_INFO_MOD_DATE,
        author             = lib.HPDF_INFO_AUTHOR,
        creator            = lib.HPDF_INFO_CREATOR,
        producer           = lib.HPDF_INFO_PRODUCER,
        title              = lib.HPDF_INFO_TITLE,
        subject            = lib.HPDF_INFO_SUBJECT,
        keywords           = lib.HPDF_INFO_KEYWORDS,
        trapped            = lib.HPDF_INFO_TRAPPED,
        gtspdfx            = lib.HPDF_INFO_GTS_PDFX,
        eof                = lib.HPDF_INFO_EOF
    },
    compressionmode = {
        none               = 0x00,
        text               = 0x01,
        image              = 0x02,
        metadata           = 0x04,
        all                = 0x0F,
        mask               = 0xFF
    },
    permission = {
        read               = 0,
        print              = 4,
        all                = 8,
        copy               = 16,
        edit               = 32
    }
}
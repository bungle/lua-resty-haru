# lua-resty-haru

LuaJIT FFI Bindings to Haru – Free PDF Library. This library is heavily work in progress as you can see on [TODO](#todo).
Meanwhile checkout [@tavikukko](https://github.com/tavikukko)'s [`lua-resty-hpdf`](https://github.com/tavikukko/lua-resty-hpdf).

## Synopsis

```lua
-- Some local variable declarations
local dump     = require "pl.pretty".dump
local haru     = require "resty.haru"
local hpdf     = haru.new()
local print    = print
local pages    = hpdf.pages
local fonts    = hpdf.fonts
local images   = hpdf.images
local encoders = hpdf.encoders

-- General Settings
hpdf:use "utfencodings"
hpdf:use "jpencodings"
hpdf:use "krencodings"
hpdf:use "cnsencodings"
hpdf:use "cntencodings"
hpdf:use "jpfonts"
hpdf:use "krfonts"
hpdf:use "cnsfonts"
hpdf:use "cntfonts"

-- Setting General Properties
hpdf.encoding         = "UTF-8"
hpdf.pagelayout       = "single"
hpdf.pagemode         = "outline"
hpdf.author           = "@bungle"
hpdf.creator          = "lua-resty-haru"
hpdf.title            = "Demo"
hpdf.subject          = "Testing FFI Bindings"
hpdf.keywords         = "openresty pdf haru lua luajit ffi"
hpdf.creationdate     = { 2015, 1, 1, 12, 0, 0, '+', 2, 0 }
hpdf.modificationdate = {
    year        = 2015,
    month       = 1,
    day         = 1,
    hour        = 12,
    minutes     = 0,
    seconds     = 0,
    ind         = "+",
    off_hour    = 2,
    off_minutes = 0
}

-- General Properties
print(hpdf.pagelayout)
print(hpdf.pagemode)
print(hpdf.author)
print(hpdf.creator)
print(hpdf.title)
print(hpdf.subject)
print(hpdf.keywords)
print(hpdf.creationdate)
print(hpdf.modificationdate)

-- Loading a Font
local helvetica = fonts:get "Helvetica"

-- Font Properties
print(helvetica.name)
print(helvetica.encoding)
print(helvetica.ascent)
print(helvetica.descent)
print(helvetica.xheight)
print(helvetica.capheight)
 dump(helvetica.bbox)

-- Loading a TTF Font
local name = fonts:load("DejaVuSans.ttf", true)
print(name)
local dejavu = fonts:get(name, "UTF-8")

-- Font Properties
print(dejavu.name)
print(dejavu.encoding)
print(dejavu.ascent)
print(dejavu.descent)
print(dejavu.xheight)
print(dejavu.capheight)
 dump(dejavu.bbox)

-- Current Encoder
local encoder = hpdf.encoder

-- Encoder Properties
print(encoder.type)
print(encoder.writingmode)

-- Getting an Encoder
local gbeuch = encoders:get "GB-EUC-H"

-- Encoder Properties
print(gbeuch.type)
print(gbeuch.writingmode)

-- Adding a Page
local page = pages:add()

-- Page Properties
print(page.width)
print(page.height)
print(page.grayfill)
print(page.graystroke)
print(page.charspace)
print(page.wordspace)
print(page.horizontalscaling)
print(page.textleading)
print(page.textrise)
print(page.textrenderingmode)
print(page.fontsize)
print(page.linewidth)
print(page.linecap)
print(page.linejoin)
print(page.flatness)
print(page.gmode)
print(page.gdepth)
print(page.strokingcolorspace)
print(page.fillingcolorspace)
 dump(page.rgbfill)
 dump(page.rgbstroke)
 dump(page.cmykfill)
 dump(page.cmykstroke)

local x, y = page:pos()
print(x, y)

local x, y = page:textpos()
print(x, y)

-- Setting Page Properties
page.width             = page.height
page.height            = page.width
page.grayfill          = page.grayfill
page.graystroke        = page.graystroke
page.charspace         = page.charspace
page.wordspace         = page.wordspace
page.horizontalscaling = page.horizontalscaling
page.textleading       = page.textleading
page.textrise          = page.textrise
page.textrenderingmode = page.textrenderingmode
page.linewidth         = page.linewidth
page.miterlimit        = page.miterlimit
page.linecap           = page.linecap
page.linejoin          = page.linejoin
page.rgbfill           = page.rgbfill
page.rgbstroke         = page.rgbstroke
page.cmykfill          = page.cmykfill
page.cmykstroke        = page.cmykstroke

-- Setting Page Size
page:size("a4", "landscape")

-- Inserting a new Page before existing
page = pages:insert(page)

-- Setting a Font
page:font(dejavu, 18)

-- Getting Current Font
local font = page:font()

print(font.name)
print(font.encoding)
print(font.ascent)
print(font.descent)
print(font.xheight)
print(font.capheight)
 dump(font.bbox)

-- Writing Text
page:begintext()
page:text(50, 400, "Hello")
page:text(0, 400, 150, 200, "World", "right")
page:textmove(100, 300)
page:text "Testing"
page:ln()
page:text "... it works - How about UTF-8 ÄÖÅäöå€!"
page:text("Hey, I'm on a new line!", true)
page:endtext()

-- Writing Text (alternative)
page:begintext()
page:textout(50, 450, "Hello")
page:textrect(0, 450, 150, 200, "World", "right")
page:textmove(100, 150)
page:textshow "Testing"
page:textshow "... it works!"
page:textshow("Hey, I'm on a new line!", true)
page:endtext()

-- Measuring Text
print(page:textwidth("hello"))

-- Drawing Shapes
page:circle(100, 100, 50)
page:rectangle(150, 150, 100, 100)
page:ellipse(300, 300, 75, 50)
page:stroke()

-- Drawing Arcs
page:arc(400, 400, 50, 180, 360)
page:stroke()

-- Drawing Lines
page.linewidth = 10
page.linecap = "round"
page:move(200, 300)
page:line(400, 300)
page:closepathstroke()

-- Drawing Curves
page:move(200, 300)
page:curve(400, 300, 500, 550, 400, 300)
page:stroke()

-- Loading a Image
local logo = images:load "logo.png"
local w, h = logo:size()
print(w, h)

-- Image Properties
print(logo.width)
print(logo.height)
print(logo.colorspace)
print(logo.bitspercomponent)

-- Drawing Image
page:image(logo, 450, 450, 100, 100)

-- Creating a Destination
local dest = page:destination();

-- Destination Properties
dest.xyz = { 10, 20, 10 }
dest.xyz = {
    left = 10,
    top  = 20,
    zoom = 10
}

-- Calling Destination Methods
dest:fit()
dest:fitb()
dest:fith(20)
dest:fitbh(20)
dest:fitbv(20)
dest:fitv(10)
dest:fitr(10, 20, 10, 20)

-- Creating Outline
local outline = hpdf:outline(nil, "Outline")

-- Setting Outline Properties
outline.destination = dest
outline.opened      = true

-- Creating Annotation
local annotation = page:textannotation(10, 600, 200, 500, "Test Annotation")

-- Setting Annotation Properties
annotation.opened = true
annotation.icon   = "help"

-- Setting Encryption and Permission
hpdf.password    = {
    owner = "demo-owner",
    user  = "demo-user"
}
hpdf.encryption  = "r3"
hpdf.permission  = "read"
hpdf.compression = "all"

-- Setting Page Labels
hpdf:pagelabel(0, "upperroman", 1, "");

-- Saving PDF
hpdf:save "demo.pdf"
```

## TODO

##### Basic Functions

* [x] ~~HPDF_New~~
* [x] ~~HPDF_Free~~
* [ ] HPDF_NewDoc
* [ ] HPDF_FreeDoc
* [x] ~~HPDF_SaveToFile~~
* [ ] HPDF_SaveToStream
* [ ] HPDF_GetStreamSize
* [ ] HPDF_ReadFromStream
* [ ] HPDF_ResetStream
* [ ] HPDF_HasDoc
* [ ] HPDF_SetErrorHandler
* [ ] HPDF_GetError
* [ ] HPDF_ResetError

##### Pages Handling

* [ ] HPDF_SetPagesConfiguration
* [x] ~~HPDF_SetPageLayout~~
* [x] ~~HPDF_GetPageLayout~~
* [x] ~~HPDF_SetPageMode~~
* [x] ~~HPDF_GetPageMode~~
* [ ] HPDF_SetOpenAction
* [x] ~~HPDF_GetCurrentPage~~
* [x] ~~HPDF_AddPage~~
* [x] ~~HPDF_InsertPage~~

##### Font Handling

* [x] ~~HPDF_AddPageLabel~~ (why is this here?)
* [x] ~~HPDF_GetFont~~
* [ ] HPDF_LoadType1FontFromFile
* [x] ~~HPDF_LoadTTFontFromFile~~
* [ ] HPDF_LoadTTFontFromFile2
* [x] ~~HPDF_UseJPFonts~~
* [x] ~~HPDF_UseKRFonts~~
* [x] ~~HPDF_UseCNSFonts~~
* [x] ~~HPDF_UseCNTFonts~~

##### Encodings

* [x] ~~HPDF_GetEncoder~~
* [x] ~~HPDF_GetCurrentEncoder~~
* [x] ~~HPDF_SetCurrentEncoder~~
* [x] ~~HPDF_UseJPEncodings~~
* [x] ~~HPDF_UseKREncodings~~
* [x] ~~HPDF_UseCNSEncodings~~
* [x] ~~HPDF_UseCNTEncodings~~
* [x] ~~HPDF_UseUTFEncodings~~

##### Other Functions

* [x] ~~HPDF_CreateOutline~~
* [x] ~~HPDF_LoadPngImageFromFile~~
* [ ] HPDF_LoadPngImageFromFile2
* [ ] HPDF_LoadRawImageFromFile
* [ ] HPDF_LoadRawImageFromMem
* [ ] HPDF_LoadPngImageFromMem
* [ ] HPDF_LoadJpegImageFromMem
* [x] ~~HPDF_LoadJpegImageFromFile~~
* [x] ~~HPDF_SetInfoAttr~~
* [x] ~~HPDF_GetInfoAttr~~
* [x] ~~HPDF_SetInfoDateAttr~~
* [x] ~~HPDF_SetPassword~~
* [x] ~~HPDF_SetPermission~~
* [x] ~~HPDF_SetEncryptionMode~~
* [x] ~~HPDF_SetCompressionMode~~

##### Page

* [x] ~~HPDF_Page_SetWidth~~
* [x] ~~HPDF_Page_SetHeight~~
* [x] ~~HPDF_Page_SetSize~~
* [ ] HPDF_Page_SetRotate
* [x] ~~HPDF_Page_GetWidth~~
* [x] ~~HPDF_Page_GetHeight~~
* [x] ~~HPDF_Page_CreateDestination~~
* [x] ~~HPDF_Page_CreateTextAnnot~~
* [ ] HPDF_Page_CreateLinkAnnot
* [ ] HPDF_Page_CreateURILinkAnnot
* [x] ~~HPDF_Page_TextWidth~~
* [ ] HPDF_Page_MeasureText
* [x] ~~HPDF_Page_GetGMode~~
* [x] ~~HPDF_Page_GetCurrentPos~~
* [x] ~~HPDF_Page_GetCurrentTextPos~~
* [x] ~~HPDF_Page_GetCurrentFont~~
* [x] ~~HPDF_Page_GetCurrentFontSize~~
* [ ] HPDF_Page_GetTransMatrix
* [x] ~~HPDF_Page_GetLineWidth~~
* [x] ~~HPDF_Page_GetLineCap~~
* [x] ~~HPDF_Page_GetLineJoin~~
* [x] ~~HPDF_Page_GetMiterLimit~~
* [ ] HPDF_Page_GetDash
* [x] ~~HPDF_Page_GetFlat~~
* [x] ~~HPDF_Page_GetCharSpace~~
* [x] ~~HPDF_Page_GetWordSpace~~
* [x] ~~HPDF_Page_GetHorizontalScalling~~
* [x] ~~HPDF_Page_GetTextLeading~~
* [x] ~~HPDF_Page_GetTextRenderingMode~~
* [x] ~~HPDF_Page_GetTextRise~~
* [x] ~~HPDF_Page_GetRGBFill~~
* [x] ~~HPDF_Page_GetRGBStroke~~
* [x] ~~HPDF_Page_GetCMYKFill~~
* [x] ~~HPDF_Page_GetCMYKStroke~~
* [x] ~~HPDF_Page_GetGrayFill~~
* [x] ~~HPDF_Page_GetGrayStroke~~
* [x] ~~HPDF_Page_GetStrokingColorSpace~~
* [x] ~~HPDF_Page_GetFillingColorSpace~~
* [ ] HPDF_Page_GetTextMatrix
* [x] ~~HPDF_Page_GetGStateDepth~~
* [ ] HPDF_Page_SetSlideShow
* [ ] HPDF_Page_New_Content_Stream
* [ ] HPDF_Page_Insert_Shared_Content_Stream

##### Graphics

* [x] ~~HPDF_Page_Arc~~
* [x] ~~HPDF_Page_BeginText~~
* [x] ~~HPDF_Page_Circle~~
* [x] ~~HPDF_Page_Clip~~
* [x] ~~HPDF_Page_ClosePath~~
* [x] ~~HPDF_Page_ClosePathStroke~~
* [x] ~~HPDF_Page_ClosePathEofillStroke~~
* [x] ~~HPDF_Page_ClosePathFillStroke~~
* [x] ~~HPDF_Page_Concat~~
* [x] ~~HPDF_Page_CurveTo~~
* [ ] HPDF_Page_CurveTo2
* [ ] HPDF_Page_CurveTo3
* [x] ~~HPDF_Page_DrawImage~~
* [x] ~~HPDF_Page_Ellipse~~
* [x] ~~HPDF_Page_EndPath~~
* [x] ~~HPDF_Page_EndText~~
* [x] ~~HPDF_Page_Eoclip~~
* [x] ~~HPDF_Page_Eofill~~
* [x] ~~HPDF_Page_EofillStroke~~
* [ ] HPDF_Page_ExecuteXObject
* [x] ~~HPDF_Page_Fill~~
* [x] ~~HPDF_Page_FillStroke~~
* [x] ~~HPDF_Page_GRestore~~
* [x] ~~HPDF_Page_GSave~~
* [x] ~~HPDF_Page_LineTo~~
* [x] ~~HPDF_Page_MoveTextPos~~
* [ ] HPDF_Page_MoveTextPos2
* [x] ~~HPDF_Page_MoveTo~~
* [x] ~~HPDF_Page_MoveToNextLine~~
* [x] ~~HPDF_Page_Rectangle~~
* [x] ~~HPDF_Page_SetCharSpace~~
* [x] ~~HPDF_Page_SetCMYKFill~~
* [x] ~~HPDF_Page_SetCMYKStroke~~
* [ ] HPDF_Page_SetDash
* [ ] HPDF_Page_SetExtGState
* [x] ~~HPDF_Page_SetFontAndSize~~
* [x] ~~HPDF_Page_SetGrayFill~~
* [x] ~~HPDF_Page_SetGrayStroke~~
* [x] ~~HPDF_Page_SetHorizontalScalling~~
* [x] ~~HPDF_Page_SetLineCap~~
* [x] ~~HPDF_Page_SetLineJoin~~
* [x] ~~HPDF_Page_SetLineWidth~~
* [x] ~~HPDF_Page_SetMiterLimit~~
* [x] ~~HPDF_Page_SetRGBFill~~
* [x] ~~HPDF_Page_SetRGBStroke~~
* [x] ~~HPDF_Page_SetTextLeading~~
* [ ] HPDF_Page_SetTextMatrix
* [x] ~~HPDF_Page_SetTextRenderingMode~~
* [x] ~~HPDF_Page_SetTextRise~~
* [x] ~~HPDF_Page_SetWordSpace~~
* [x] ~~HPDF_Page_ShowText~~
* [x] ~~HPDF_Page_ShowTextNextLine~~
* [x] ~~HPDF_Page_ShowTextNextLineEx~~
* [x] ~~HPDF_Page_Stroke~~
* [x] ~~HPDF_Page_TextOut~~
* [x] ~~HPDF_Page_TextRect~~

##### Fonts

* [x] ~~HPDF_Font_GetFontName~~
* [x] ~~HPDF_Font_GetEncodingName~~
* [ ] HPDF_Font_GetUnicodeWidth
* [x] ~~HPDF_Font_GetBBox~~
* [x] ~~HPDF_Font_GetAscent~~
* [x] ~~HPDF_Font_GetDescent~~
* [x] ~~HPDF_Font_GetXHeight~~
* [x] ~~HPDF_Font_GetCapHeight~~
* [ ] HPDF_Font_TextWidth
* [ ] HPDF_Font_MeasureText

##### Encodings

* [x] ~~HPDF_Encoder_GetType~~
* [ ] HPDF_Encoder_GetByteType
* [ ] HPDF_Encoder_GetUnicode
* [x] ~~HPDF_Encoder_GetWritingMode~~

##### Annotations

* [ ] HPDF_LinkAnnot_SetHighlightMode
* [ ] HPDF_LinkAnnot_SetBorderStyle
* [x] ~~HPDF_TextAnnot_SetIcon~~
* [x] ~~HPDF_TextAnnot_SetOpened~~
* [ ] HPDF_Annotation_SetBorderStyle

##### Outline

* [x] ~~HPDF_Outline_SetOpened~~
* [x] ~~HPDF_Outline_SetDestination~~

##### Destination

* [x] ~~HPDF_Destination_SetXYZ~~
* [x] ~~HPDF_Destination_SetFit~~
* [x] ~~HPDF_Destination_SetFitH~~
* [x] ~~HPDF_Destination_SetFitV~~
* [x] ~~HPDF_Destination_SetFitR~~
* [x] ~~HPDF_Destination_SetFitB~~
* [x] ~~HPDF_Destination_SetFitBH~~
* [x] ~~HPDF_Destination_SetFitBV~~

##### Image

* [x] ~~HPDF_Image_GetSize~~
* [x] ~~HPDF_Image_GetWidth~~
* [x] ~~HPDF_Image_GetHeight~~
* [x] ~~HPDF_Image_GetBitsPerComponent~~
* [x] ~~HPDF_Image_GetColorSpace~~
* [ ] HPDF_Image_SetColorMask
* [ ] HPDF_Image_SetMaskImage

## License

`lua-resty-haru` uses two clause BSD license.

```
Copyright (c) 2016, Aapo Talvensaari
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
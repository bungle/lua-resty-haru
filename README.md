# lua-resty-haru

LuaJIT FFI Bindings to Haru – Free PDF Library. This library is almost done as you can see on [TODO](#todo). Some missing API bindings will be added shortly, or on request.

## Requirements

- LuaJIT - [original](https://luajit.org) or [OpenResty's branch](https://github.com/openresty/luajit2)
- [libharu](https://github.com/libharu/libharu) version 2.4 or later

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
 dump(page.textmatrix)
 dump(page.transmatrix)
 dump(page.dash)

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
page.dash              = page.dash
page.rotate            = 90

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
page.textmatrix = page.textmatrix
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
page.textmatrix = page.textmatrix
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

-- Drawing Dashed Lines
page.linewidth = 2
page.linecap = "butt"
page.dash = {
    pattern = { 8, 7, 2, 7 },
    phase   = 0,
    n       = 4
}
page:move(200, 600)
page:line(400, 600)
page:closepathstroke()

-- Drawing Curves
page.linewidth = 10
page.linecap = "round"
page.dash = nil
page:move(200, 300)
page:curve(400, 300, 500, 550, 400, 300)
page:stroke()

-- Loading a Image
local logo = images:load "logo.png"

-- Image Properties
print(logo.width)
print(logo.height)
print(logo.colorspace)
print(logo.bitspercomponent)
 dump(logo.size)

-- Setting Image Properties
logo.colormask = {
    rmin = 50,
    rmax = 150,
    gmin = 50,
    gmax = 150,
    bmin = 50,
    bmax = 150
}

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
    owner = "owner",
    user  = "user"
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

The most of the bindings are implemented, but there are a few that are still work in progress.

##### Basic Functions

* [ ] HPDF_NewDoc
* [ ] HPDF_FreeDoc
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
* [ ] HPDF_SetOpenAction

##### Font Handling

* [ ] HPDF_LoadType1FontFromFile
* [ ] HPDF_LoadTTFontFromFile2

##### Other Functions

* [ ] HPDF_LoadPngImageFromFile2
* [ ] HPDF_LoadRawImageFromFile
* [ ] HPDF_LoadRawImageFromMem
* [ ] HPDF_LoadPngImageFromMem
* [ ] HPDF_LoadJpegImageFromMem

##### Page

* [ ] HPDF_Page_CreateLinkAnnot
* [ ] HPDF_Page_CreateURILinkAnnot
* [ ] HPDF_Page_MeasureText
* [ ] HPDF_Page_SetSlideShow
* [ ] HPDF_Page_New_Content_Stream
* [ ] HPDF_Page_Insert_Shared_Content_Stream

##### Graphics

* [ ] HPDF_Page_ExecuteXObject
* [ ] HPDF_Page_SetExtGState

##### Fonts

* [ ] HPDF_Font_GetUnicodeWidth
* [ ] HPDF_Font_TextWidth
* [ ] HPDF_Font_MeasureText

##### Encodings

* [ ] HPDF_Encoder_GetByteType
* [ ] HPDF_Encoder_GetUnicode

##### Annotations

* [ ] HPDF_LinkAnnot_SetHighlightMode
* [ ] HPDF_LinkAnnot_SetBorderStyle
* [ ] HPDF_Annotation_SetBorderStyle

##### Image

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

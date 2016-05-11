# lua-resty-haru

LuaJIT FFI Bindings to Haru – Free PDF Library. This library is heavily work in progress as you can see on [TODO](#todo).
Meanwhile checkout [@tavikukko](https://github.com/tavikukko)'s [`lua-resty-hpdf`](https://github.com/tavikukko/lua-resty-hpdf).

## Synopsis

```lua
local print     = print
local haru      = require "resty.haru"
local hpdf      = haru.new()
local pages     = hpdf.pages
local images    = hpdf.images
local fonts     = hpdf.fonts
local page      = pages:add()
local text      = page.text
local font      = page.font
local image     = page.image
local helvetica = fonts:get "Helvetica"

print(helvetica.name)
print(helvetica.encoding)
print(helvetica.ascent)
print(helvetica.descent)
print(page.width)
print(page.height)

hpdf:use "utfencodings"
hpdf:use "jpencodings"
hpdf:use "krencodings"
hpdf:use "cnsencodings"
hpdf:use "cntencodings"
hpdf:use "jpfonts"
hpdf:use "krfonts"
hpdf:use "cnsfonts"
hpdf:use "cntfonts"

font:set(helvetica, 18)

print(text.charspace)
print(text.wordspace)
print(text.horizontalscaling)
print(text.leading)
print(text.renderingmode)
print(text.rise)
print(text.grayfill)
print(text.graystroke)

text:begin()
text:out(100, 100, "Hello")
text:rect(200, 200, 400, 400, "World", "right")
text:finish()

local logo = images:load "logo.png"

print(logo.width)
print(logo.height)
print(logo.colorspace)
print(logo.bitspercomponent)

image:draw(logo, 300, 300)
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
* [ ] HPDF_SetPageLayout
* [ ] HPDF_GetPageLayout
* [ ] HPDF_SetPageMode
* [ ] HPDF_GetPageMode
* [ ] HPDF_SetOpenAction
* [ ] HPDF_GetCurrentPage
* [x] ~~HPDF_AddPage~~
* [ ] HPDF_InsertPage

##### Font Handling

* [ ] HPDF_AddPageLabel
* [x] ~~HPDF_GetFont~~
* [ ] HPDF_LoadType1FontFromFile
* [ ] HPDF_LoadTTFontFromFile
* [ ] HPDF_LoadTTFontFromFile2
* [x] ~~HPDF_UseJPFonts~~
* [x] ~~HPDF_UseKRFonts~~
* [x] ~~HPDF_UseCNSFonts~~
* [x] ~~HPDF_UseCNTFonts~~

##### Encodings

* [ ] HPDF_GetEncoder
* [ ] HPDF_GetCurrentEncoder
* [ ] HPDF_SetCurrentEncoder
* [x] ~~HPDF_UseJPEncodings~~
* [x] ~~HPDF_UseKREncodings~~
* [x] ~~HPDF_UseCNSEncodings~~
* [x] ~~HPDF_UseCNTEncodings~~
* [x] ~~HPDF_UseUTFEncodings~~

##### Other Functions

* [ ] HPDF_CreateOutline
* [x] ~~HPDF_LoadPngImageFromFile~~
* [ ] HPDF_LoadPngImageFromFile2
* [ ] HPDF_LoadRawImageFromFile
* [ ] HPDF_LoadRawImageFromMem
* [ ] HPDF_LoadPngImageFromMem
* [ ] HPDF_LoadJpegImageFromMem
* [x] ~~HPDF_LoadJpegImageFromFile~~
* [ ] HPDF_SetInfoAttr
* [ ] HPDF_GetInfoAttr
* [ ] HPDF_SetInfoDateAttr
* [ ] HPDF_SetPassword
* [ ] HPDF_SetPermission
* [ ] HPDF_SetEncryptionMode
* [ ] HPDF_SetCompressionMode

##### Page

* [x] ~~HPDF_Page_SetWidth~~
* [x] ~~HPDF_Page_SetHeight~~
* [ ] HPDF_Page_SetSize
* [ ] HPDF_Page_SetRotate
* [x] ~~HPDF_Page_GetWidth~~
* [x] ~~HPDF_Page_GetHeight~~
* [ ] HPDF_Page_CreateDestination
* [ ] HPDF_Page_CreateTextAnnot
* [ ] HPDF_Page_CreateLinkAnnot
* [ ] HPDF_Page_CreateURILinkAnnot
* [ ] HPDF_Page_TextWidth
* [ ] HPDF_Page_MeasureText
* [ ] HPDF_Page_GetGMode
* [ ] HPDF_Page_GetCurrentPos
* [ ] HPDF_Page_GetCurrentTextPos
* [ ] HPDF_Page_GetCurrentFont
* [ ] HPDF_Page_GetCurrentFontSize
* [ ] HPDF_Page_GetTransMatrix
* [ ] HPDF_Page_GetLineWidth
* [ ] HPDF_Page_GetLineCap
* [ ] HPDF_Page_GetLineJoin
* [ ] HPDF_Page_GetMiterLimit
* [ ] HPDF_Page_GetDash
* [ ] HPDF_Page_GetFlat
* [x] ~~HPDF_Page_GetCharSpace~~
* [x] ~~HPDF_Page_GetWordSpace~~
* [x] ~~HPDF_Page_GetHorizontalScalling~~
* [x] ~~HPDF_Page_GetTextLeading~~
* [x] ~~HPDF_Page_GetTextRenderingMode~~
* [x] ~~HPDF_Page_GetTextRise~~
* [ ] HPDF_Page_GetRGBFill
* [ ] HPDF_Page_GetRGBStroke
* [ ] HPDF_Page_GetCMYKFill
* [ ] HPDF_Page_GetCMYKStroke
* [x] ~~HPDF_Page_GetGrayFill~~
* [x] ~~HPDF_Page_GetGrayStroke~~
* [ ] HPDF_Page_GetStrokingColorSpace
* [ ] HPDF_Page_GetFillingColorSpace
* [ ] HPDF_Page_GetTextMatrix
* [ ] HPDF_Page_GetGStateDepth
* [ ] HPDF_Page_SetSlideShow
* [ ] HPDF_Page_New_Content_Stream
* [ ] HPDF_Page_Insert_Shared_Content_Stream

##### Graphics

* [ ] HPDF_Page_Arc
* [x] ~~HPDF_Page_BeginText~~
* [ ] HPDF_Page_Circle
* [ ] HPDF_Page_Clip
* [ ] HPDF_Page_ClosePath
* [ ] HPDF_Page_ClosePathStroke
* [ ] HPDF_Page_ClosePathEofillStroke
* [ ] HPDF_Page_ClosePathFillStroke
* [ ] HPDF_Page_Concat
* [ ] HPDF_Page_CurveTo
* [ ] HPDF_Page_CurveTo2
* [ ] HPDF_Page_CurveTo3
* [x] ~~HPDF_Page_DrawImage~~
* [ ] HPDF_Page_Ellipse
* [ ] HPDF_Page_EndPath
* [x] ~~HPDF_Page_EndText~~
* [ ] HPDF_Page_Eoclip
* [ ] HPDF_Page_Eofill
* [ ] HPDF_Page_EofillStroke
* [ ] HPDF_Page_ExecuteXObject
* [ ] HPDF_Page_Fill
* [ ] HPDF_Page_FillStroke
* [ ] HPDF_Page_GRestore
* [ ] HPDF_Page_GSave
* [ ] HPDF_Page_LineTo
* [ ] HPDF_Page_MoveTextPos
* [ ] HPDF_Page_MoveTextPos2
* [ ] HPDF_Page_MoveTo
* [ ] HPDF_Page_MoveToNextLine
* [ ] HPDF_Page_Rectangle
* [ ] HPDF_Page_SetCharSpace
* [ ] HPDF_Page_SetCMYKFill
* [ ] HPDF_Page_SetCMYKStroke
* [ ] HPDF_Page_SetDash
* [ ] HPDF_Page_SetExtGState
* [ ] HPDF_Page_SetFontAndSize
* [ ] HPDF_Page_SetGrayFill
* [ ] HPDF_Page_SetGrayStroke
* [ ] HPDF_Page_SetHorizontalScalling
* [ ] HPDF_Page_SetLineCap
* [ ] HPDF_Page_SetLineJoin
* [ ] HPDF_Page_SetLineWidth
* [ ] HPDF_Page_SetMiterLimit
* [ ] HPDF_Page_SetRGBFill
* [ ] HPDF_Page_SetRGBStroke
* [ ] HPDF_Page_SetTextLeading
* [ ] HPDF_Page_SetTextMatrix
* [ ] HPDF_Page_SetTextRenderingMode
* [ ] HPDF_Page_SetTextRise
* [ ] HPDF_Page_SetWordSpace
* [ ] HPDF_Page_ShowText
* [ ] HPDF_Page_ShowTextNextLine
* [ ] HPDF_Page_ShowTextNextLineEx
* [ ] HPDF_Page_Stroke
* [x] ~~HPDF_Page_TextOut~~
* [x] ~~HPDF_Page_TextRect~~

##### Fonts

* [x] ~~HPDF_Font_GetFontName~~
* [x] ~~HPDF_Font_GetEncodingName~~
* [ ] HPDF_Font_GetUnicodeWidth
* [ ] HPDF_Font_GetBBox
* [x] ~~HPDF_Font_GetAscent~~
* [x] ~~HPDF_Font_GetDescent~~
* [ ] HPDF_Font_GetXHeight
* [ ] HPDF_Font_GetCapHeight
* [ ] HPDF_Font_TextWidth
* [ ] HPDF_Font_MeasureText

##### Encodings

* [ ] HPDF_Encoder_GetType
* [ ] HPDF_Encoder_GetByteType
* [ ] HPDF_Encoder_GetUnicode
* [ ] HPDF_Encoder_GetWritingMode

##### Annotations

* [ ] HPDF_LinkAnnot_SetHighlightMode
* [ ] HPDF_LinkAnnot_SetBorderStyle
* [ ] HPDF_TextAnnot_SetIcon
* [ ] HPDF_TextAnnot_SetOpened
* [ ] HPDF_Annotation_SetBorderStyle

##### Outline

* [ ] HPDF_Outline_SetOpened
* [ ] HPDF_Outline_SetDestination

##### Destination

* [ ] HPDF_Destination_SetXYZ
* [ ] HPDF_Destination_SetFit
* [ ] HPDF_Destination_SetFitH
* [ ] HPDF_Destination_SetFitV
* [ ] HPDF_Destination_SetFitR
* [ ] HPDF_Destination_SetFitB
* [ ] HPDF_Destination_SetFitBH
* [ ] HPDF_Destination_SetFitBV

##### Image

* [ ] HPDF_Image_GetSize
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
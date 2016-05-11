local ffi = require "ffi"
local ffi_cdef = ffi.cdef
local ffi_load = ffi.load

ffi_cdef[[
typedef unsigned long HPDF_STATUS;
typedef float HPDF_REAL;
typedef signed int HPDF_INT;
typedef unsigned int HPDF_UINT;
typedef void *HPDF_HANDLE;
typedef HPDF_HANDLE HPDF_Doc;
typedef HPDF_HANDLE HPDF_Page;
typedef HPDF_HANDLE HPDF_Pages;
typedef HPDF_HANDLE HPDF_Stream;
typedef HPDF_HANDLE HPDF_Image;
typedef HPDF_HANDLE HPDF_Font;
typedef HPDF_HANDLE HPDF_Outline;
typedef HPDF_HANDLE HPDF_Encoder;
typedef HPDF_HANDLE HPDF_3DMeasure;
typedef HPDF_HANDLE HPDF_ExData;
typedef HPDF_HANDLE HPDF_Destination;
typedef HPDF_HANDLE HPDF_XObject;
typedef HPDF_HANDLE HPDF_Annotation;
typedef HPDF_HANDLE HPDF_ExtGState;
typedef HPDF_HANDLE HPDF_FontDef;
typedef HPDF_HANDLE HPDF_U3D;
typedef HPDF_HANDLE HPDF_JavaScript;
typedef HPDF_HANDLE HPDF_Error;
typedef HPDF_HANDLE HPDF_MMgr;
typedef HPDF_HANDLE HPDF_Dict;
typedef HPDF_HANDLE HPDF_EmbeddedFile;
typedef HPDF_HANDLE HPDF_OutputIntent;
typedef HPDF_HANDLE HPDF_Xref;
typedef void (*HPDF_Error_Handler) (HPDF_STATUS error_no, HPDF_STATUS detail_no, void *user_data);
typedef enum _HPDF_TextAlignment {
    HPDF_TALIGN_LEFT = 0,
    HPDF_TALIGN_RIGHT,
    HPDF_TALIGN_CENTER,
    HPDF_TALIGN_JUSTIFY
} HPDF_TextAlignment;
   HPDF_Doc HPDF_New(HPDF_Error_Handler user_error_fn, void *user_data);
       void HPDF_Free(HPDF_Doc pdf);
HPDF_STATUS HPDF_SaveToFile(HPDF_Doc pdf, const char *file_name);
  HPDF_Page HPDF_AddPage(HPDF_Doc pdf);
  HPDF_Font HPDF_GetFont (HPDF_Doc pdf, const char *font_name, const char *encoding_name);
HPDF_STATUS HPDF_Page_BeginText(HPDF_Page page);
HPDF_STATUS HPDF_Page_EndText(HPDF_Page page);
HPDF_STATUS HPDF_Page_TextOut(HPDF_Page page, HPDF_REAL xpos, HPDF_REAL ypos, const char *text);
HPDF_STATUS HPDF_Page_TextRect (HPDF_Page page, HPDF_REAL left, HPDF_REAL top, HPDF_REAL right, HPDF_REAL bottom, const char *text, HPDF_TextAlignment align, HPDF_UINT *len);
HPDF_STATUS HPDF_Page_SetFontAndSize(HPDF_Page page, HPDF_Font font, HPDF_REAL size);
  HPDF_REAL HPDF_Page_GetWidth(HPDF_Page page);
  HPDF_REAL HPDF_Page_GetHeight(HPDF_Page page);
HPDF_STATUS HPDF_Page_SetWidth(HPDF_Page page, HPDF_REAL value);
HPDF_STATUS HPDF_Page_SetHeight(HPDF_Page page, HPDF_REAL value);
HPDF_STATUS HPDF_Page_DrawImage(HPDF_Page page, HPDF_Image image, HPDF_REAL x, HPDF_REAL y, HPDF_REAL width, HPDF_REAL height);
HPDF_STATUS HPDF_UseJPEncodings(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseKREncodings(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseCNSEncodings(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseCNTEncodings (HPDF_Doc pdf);
HPDF_STATUS HPDF_UseUTFEncodings (HPDF_Doc pdf);
HPDF_STATUS HPDF_UseJPFonts(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseKRFonts(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseCNSFonts(HPDF_Doc pdf);
HPDF_STATUS HPDF_UseCNTFonts(HPDF_Doc pdf);
const char* HPDF_Font_GetFontName(HPDF_Font font);
const char* HPDF_Font_GetEncodingName(HPDF_Font font);
   HPDF_INT HPDF_Font_GetAscent(HPDF_Font font);
   HPDF_INT HPDF_Font_GetDescent(HPDF_Font font);
 HPDF_Image HPDF_LoadPngImageFromFile(HPDF_Doc pdf, const char *filename);
 HPDF_Image HPDF_LoadJpegImageFromFile(HPDF_Doc pdf, const char  *filename);
  HPDF_UINT HPDF_Image_GetWidth(HPDF_Image image);
  HPDF_UINT HPDF_Image_GetHeight(HPDF_Image image);
const char* HPDF_Image_GetColorSpace(HPDF_Image image);
  HPDF_UINT HPDF_Image_GetBitsPerComponent(HPDF_Image image);
]]

--[[
Basic Functions:
[done] HPDF_New()
[done] HPDF_Free()
HPDF_NewDoc()
HPDF_FreeDoc()
[done] HPDF_SaveToFile()
HPDF_SaveToStream()
HPDF_GetStreamSize()
HPDF_ReadFromStream()
HPDF_ResetStream()
HPDF_HasDoc()
HPDF_SetErrorHandler()
HPDF_GetError()
HPDF_ResetError()
Pages Handling:
HPDF_SetPagesConfiguration()
HPDF_SetPageLayout()
HPDF_GetPageLayout()
HPDF_SetPageMode()
HPDF_GetPageMode()
HPDF_SetOpenAction()
HPDF_GetCurrentPage()
[done] HPDF_AddPage()
HPDF_InsertPage()
Font Handling:
HPDF_AddPageLabel()
[done] HPDF_GetFont()
HPDF_LoadType1FontFromFile()
HPDF_LoadTTFontFromFile()
HPDF_LoadTTFontFromFile2()
[done] HPDF_UseJPFonts()
[done] HPDF_UseKRFonts()
[done] HPDF_UseCNSFonts()
[done] HPDF_UseCNTFonts()
Encodings:
HPDF_GetEncoder()
HPDF_GetCurrentEncoder()
HPDF_SetCurrentEncoder()
[done] HPDF_UseJPEncodings()
[done] HPDF_UseKREncodings()
[done] HPDF_UseCNSEncodings()
[done] HPDF_UseCNTEncodings()
[done] HPDF_UseUTFEncodings()
Other Functions:
HPDF_CreateOutline()
[done] HPDF_LoadPngImageFromFile()
HPDF_LoadPngImageFromFile2()
HPDF_LoadRawImageFromFile()
HPDF_LoadRawImageFromMem()
HPDF_LoadPngImageFromMem()
HPDF_LoadJpegImageFromMem()
[done] HPDF_LoadJpegImageFromFile()
HPDF_SetInfoAttr()
HPDF_GetInfoAttr()
HPDF_SetInfoDateAttr()
HPDF_SetPassword()
HPDF_SetPermission()
HPDF_SetEncryptionMode()
HPDF_SetCompressionMode()
Page:
[done] HPDF_Page_SetWidth()
[done] HPDF_Page_SetHeight()
HPDF_Page_SetSize()
HPDF_Page_SetRotate()
[done] HPDF_Page_GetWidth()
[done] HPDF_Page_GetHeight()
HPDF_Page_CreateDestination()
HPDF_Page_CreateTextAnnot()
HPDF_Page_CreateLinkAnnot()
HPDF_Page_CreateURILinkAnnot()
HPDF_Page_TextWidth()
HPDF_Page_MeasureText()
HPDF_Page_GetGMode()
HPDF_Page_GetCurrentPos()
HPDF_Page_GetCurrentTextPos()
HPDF_Page_GetCurrentFont()
HPDF_Page_GetCurrentFontSize()
HPDF_Page_GetTransMatrix()
HPDF_Page_GetLineWidth()
HPDF_Page_GetLineCap()
HPDF_Page_GetLineJoin()
HPDF_Page_GetMiterLimit()
HPDF_Page_GetDash()
HPDF_Page_GetFlat()
HPDF_Page_GetCharSpace()
HPDF_Page_GetWordSpace()
HPDF_Page_GetHorizontalScalling()
HPDF_Page_GetTextLeading()
HPDF_Page_GetTextRenderingMode()
HPDF_Page_GetTextRise()
HPDF_Page_GetRGBFill()
HPDF_Page_GetRGBStroke()
HPDF_Page_GetCMYKFill()
HPDF_Page_GetCMYKStroke()
HPDF_Page_GetGrayFill()
HPDF_Page_GetGrayStroke()
HPDF_Page_GetStrokingColorSpace()
HPDF_Page_GetFillingColorSpace()
HPDF_Page_GetTextMatrix()
HPDF_Page_GetGStateDepth()
HPDF_Page_SetSlideShow()
HPDF_Page_New_Content_Stream()
HPDF_Page_Insert_Shared_Content_Stream()
Graphics:
HPDF_Page_Arc()
[done] HPDF_Page_BeginText()
HPDF_Page_Circle()
HPDF_Page_Clip()
HPDF_Page_ClosePath()
HPDF_Page_ClosePathStroke()
HPDF_Page_ClosePathEofillStroke()
HPDF_Page_ClosePathFillStroke()
HPDF_Page_Concat()
HPDF_Page_CurveTo()
HPDF_Page_CurveTo2()
HPDF_Page_CurveTo3()
[done] HPDF_Page_DrawImage()
HPDF_Page_Ellipse()
HPDF_Page_EndPath()
[done] HPDF_Page_EndText()
HPDF_Page_Eoclip()
HPDF_Page_Eofill()
HPDF_Page_EofillStroke()
HPDF_Page_ExecuteXObject()
HPDF_Page_Fill()
HPDF_Page_FillStroke()
HPDF_Page_GRestore()
HPDF_Page_GSave()
HPDF_Page_LineTo()
HPDF_Page_MoveTextPos()
HPDF_Page_MoveTextPos2()
HPDF_Page_MoveTo()
HPDF_Page_MoveToNextLine()
HPDF_Page_Rectangle()
HPDF_Page_SetCharSpace()
HPDF_Page_SetCMYKFill()
HPDF_Page_SetCMYKStroke()
HPDF_Page_SetDash()
HPDF_Page_SetExtGState()
HPDF_Page_SetFontAndSize()
HPDF_Page_SetGrayFill()
HPDF_Page_SetGrayStroke()
HPDF_Page_SetHorizontalScalling()
HPDF_Page_SetLineCap()
HPDF_Page_SetLineJoin()
HPDF_Page_SetLineWidth()
HPDF_Page_SetMiterLimit()
HPDF_Page_SetRGBFill()
HPDF_Page_SetRGBStroke()
HPDF_Page_SetTextLeading()
HPDF_Page_SetTextMatrix()
HPDF_Page_SetTextRenderingMode()
HPDF_Page_SetTextRise()
HPDF_Page_SetWordSpace()
HPDF_Page_ShowText()
HPDF_Page_ShowTextNextLine()
HPDF_Page_ShowTextNextLineEx()
HPDF_Page_Stroke()
[done] HPDF_Page_TextOut()
[done] HPDF_Page_TextRect()
Fonts:
[done] HPDF_Font_GetFontName()
[done] HPDF_Font_GetEncodingName()
HPDF_Font_GetUnicodeWidth()
HPDF_Font_GetBBox()
[done] HPDF_Font_GetAscent()
[done] HPDF_Font_GetDescent()
HPDF_Font_GetXHeight()
HPDF_Font_GetCapHeight()
HPDF_Font_TextWidth()
HPDF_Font_MeasureText()
Encodings:
HPDF_Encoder_GetType()
HPDF_Encoder_GetByteType()
HPDF_Encoder_GetUnicode()
HPDF_Encoder_GetWritingMode()
Annotations:
HPDF_LinkAnnot_SetHighlightMode()
HPDF_LinkAnnot_SetBorderStyle()
HPDF_TextAnnot_SetIcon()
HPDF_TextAnnot_SetOpened()
HPDF_Annotation_SetBorderStyle()
Outline:
HPDF_Outline_SetOpened()
HPDF_Outline_SetDestination()
Destination:
HPDF_Destination_SetXYZ()
HPDF_Destination_SetFit()
HPDF_Destination_SetFitH()
HPDF_Destination_SetFitV()
HPDF_Destination_SetFitR()
HPDF_Destination_SetFitB()
HPDF_Destination_SetFitBH()
HPDF_Destination_SetFitBV()
Image:
HPDF_Image_GetSize()
[done] HPDF_Image_GetWidth()
[done] HPDF_Image_GetHeight()
[done] HPDF_Image_GetBitsPerComponent()
[done] HPDF_Image_GetColorSpace()
HPDF_Image_SetColorMask()
HPDF_Image_SetMaskImage()
-- ]]

return ffi_load "hpdf"
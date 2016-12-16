#include <Array.au3>

Global $theme, $themeB

_StartupSelection()

If $themeB <> "" Then
   Global $mode = "compare"
Else
   Global $mode = "single"
EndIf


#Region: Index
If $mode = "compare" Then
   $indexFile = @ScriptDir & "\_Compare.html"
Else
   $indexFile = @ScriptDir & "\" & $theme & "\_Overview.html"
EndIf
If FileExists($indexFile) Then FileDelete($indexFile)
FileWrite($indexFile, code_Index())
#EndRegion


#Region: Categories
_GenCats("actions")
_GenCats("apps")
_GenCats("categories")
_GenCats("devices")
_GenCats("emblems")
_GenCats("emotes")
_GenCats("mimetypes")
_GenCats("places")
_GenCats("status")
#EndRegion


ShellExecute($indexFile)

Exit


Func _StartupSelection()
   $theme = InputBox("Theme Selection", "For which theme do you want to create an overview?", "Gnome")
   If @error = 1 Then Exit

   $themeB = InputBox("Theme Selection (2nd)", "To which theme do you want to compare it to?" & @CRLF & "If you leave it blank only an overview for the first Theme will be created.", "")
   If @error = 1 Then Exit

   If not FileExists(@ScriptDir & "\" & $theme) Then
	  MsgBox(16, "Not Found", "There is no such theme. Please try again.")
	  _StartupSelection()
   EndIf

   If $themeB <> "" and not FileExists(@ScriptDir & "\" & $themeB) Then
	  MsgBox(16, "Not Found (2nd)", "There is no such theme. Please try again.")
	  _StartupSelection()
   EndIf
EndFunc


Func _GenCats($cat)
   If FileExists(@ScriptDir & "\" & $theme & "\" & $cat) Then
	  ;get Files
	  $aReturn = _RecursiveFileListToArray(@ScriptDir & "\" & $theme & "\" & $cat, ".png\z|\.svg\z", 1) ;"\.png\z|\.svg\z"
	  If $mode = "compare" Then $aReturnB = _RecursiveFileListToArray(@ScriptDir & "\" & $themeB & "\" & $cat, ".png\z|\.svg\z", 1) ;"\.png\z|\.svg\z"

	  ;sort & remove duplicates
	  _ArraySort($aReturn, 0, 1)
	  $a_Files = _ArrayUnique($aReturn, "", 1)
	  ;_ArrayDisplay($a_Files)
	  If $mode = "compare" Then
		 $a_FilesA = $a_Files

		 _ArraySort($aReturnB, 0, 1)
		 $a_FilesB = _ArrayUnique($aReturnB, "", 1)
		 ;_ArrayDisplay($a_FilesB)

		 _ArrayConcatenate($a_FilesA, $a_FilesB, 1)

		 _ArraySort($a_FilesA, 0, 1)
		 $a_Files = _ArrayUnique($a_FilesA, "", 1)
		 ;_ArrayDisplay($a_Files)
	  EndIf

	  ;create HTML
	  $codeA =  code_Content_Header($cat) & @LF

	  $codeB = ""
	  If $theme = "Gnome-Colors" Then
		 For $i = 1 to $a_Files[0]
			$codeB &= code_Content_GC($a_Files[$i], $cat)
		 Next
	  Else
		 For $i = 1 to $a_Files[0]
			$codeB &= code_Content($a_Files[$i], $cat)
		 Next
	  EndIf

	  $codeC = code_Content_Bottom()

	  $code = $codeA & @LF & $codeB & @LF & $codeC

	  ;write file
	  If $mode = "compare" Then
		 $catFile = @ScriptDir & "\" & $cat & ".html"
	  Else
		 $catFile = @ScriptDir & "\" & $theme & "\" & $cat & ".html"
	  EndIf
	  If FileExists($catFile) Then FileDelete($catFile)
	  FileWrite($catFile, $code)
   EndIf
EndFunc


#Region: HTML Codes

Func code_Index()
   If $mode = "compare" Then
	  $IndexHtmlCode = '<html>' & @LF & _
						'<head>' & @LF & _
						'  <title>' & $theme & ' vs. ' & $themeB & ' Icons Collection</title>' & @LF & _
						'  <style type="text/css">' & @LF & _
						'    span.grey {color:lightgrey;font-family:verdana;font-size:10px}' & @LF & _
						'    span.orange {color:orange;font-weight:bold;font-family:verdana;font-size:14px}' & @LF & _
						'    span.white {color:white;font-weight:bold;font-family:verdana;font-size:20px}' & @LF & _
						'  </style>' & @LF & _
						'</head>' & @LF & _
						' ' & @LF & _
						'<span class="grey">' & @LF & _
						'  <a href="actions.html" target="iframe">actions</a> :  ' & @LF & _
						'  <a href="apps.html" target="iframe">apps</a> :  ' & @LF & _
						'  <a href="categories.html" target="iframe">categories</a> :  ' & @LF & _
						'  <a href="devices.html" target="iframe">devices</a> :  ' & @LF & _
						'  <a href="emblems.html" target="iframe">emblems</a> :  ' & @LF & _
						'  <a href="mimetypes.html" target="iframe">mimetypes</a> :  ' & @LF & _
						'  <a href="places.html" target="iframe">places</a> :  ' & @LF & _
						'  <a href="status.html" target="iframe">status</a> ' & @LF & _
						'</span>' & @LF & _
						'<p>' & @LF & _
						' ' & @LF & _
						'<body style="background-color: rgb(51, 51, 51);" bgcolor="gray" link="lightgrey" text="lightgrey" vlink="white">' & @LF & _
						' ' & @LF & _
						'<table style="width: 1484px;">' & @LF & _
						'  <tbody>' & @LF & _
						'    <tr>' & @LF & _
						'      <td style="width: 250px;" align="right"></td>' & @LF & _
						'      <td style="width: 617px;"><span class="orange">' & $theme & '</span></td>' & @LF & _
						'      <td style="width: 617px; background-color: rgb(102, 102, 102);"><span class="orange">' & $themeB & '</span></td>' & @LF & _
						'    </tr>' & @LF & _
						'  </tbody>' & @LF & _
						'</table>' & @LF & _
						' ' & @LF & _
						'<table style="width: 1484px;">' & @LF & _
						'  <tbody>' & @LF & _
						'    <tr>' & @LF & _
						'      <td style="width: 250px;" align="right"><span class="grey">Icon Sizes (Pixel):  </span></td>' & @LF & _
						'      <td style="width: 16px;"><span class="grey">16</span></td>' & @LF & _
						'      <td style="width: 22px;"><span class="grey">22</span></td>' & @LF & _
						'      <td style="width: 24px;"><span class="grey">24</span></td>' & @LF & _
						'      <td style="width: 32px;"><span class="grey">32</span></td>' & @LF & _
						'      <td style="width: 48px;"><span class="grey">48</span></td>' & @LF & _
						'      <td style="width: 64px;"><span class="grey">64</span></td>' & @LF & _
						'      <td style="width: 128px;"><span class="grey">128</span></td>' & @LF & _
						'      <td style="width: 256px;"><span class="grey">256</span></td>' & @LF & _
						'      <td style="width: 16px; background-color: rgb(102, 102, 102);"><span class="grey">16</span></td>' & @LF & _
						'      <td style="width: 22px; background-color: rgb(102, 102, 102);"><span class="grey">22</span></td>' & @LF & _
						'      <td style="width: 24px; background-color: rgb(102, 102, 102);"><span class="grey">24</span></td>' & @LF & _
						'      <td style="width: 32px; background-color: rgb(102, 102, 102);"><span class="grey">32</span></td>' & @LF & _
						'      <td style="width: 48px; background-color: rgb(102, 102, 102);"><span class="grey">48</span></td>' & @LF & _
						'      <td style="width: 64px; background-color: rgb(102, 102, 102);"><span class="grey">64</span></td>' & @LF & _
						'      <td style="width: 128px; background-color: rgb(102, 102, 102);"><span class="grey">128</span></td>' & @LF & _
						'      <td style="width: 256px; background-color: rgb(102, 102, 102);"><span class="grey">256</span></td>' & @LF & _
						'    </tr>' & @LF & _
						'  </tbody>' & @LF & _
						'</table>' & @LF & _
						' ' & @LF & _
						'<iframe src="actions.html" width="100%" height="90%" name="iframe" marginheight="0" marginwidth="0" frameborder="0">' & @LF & _
						'  <p>Ihr Browser kann leider keine eingebetteten Frames anzeigen: <a href="actions.html">SELFHTML</a></p>' & @LF & _
						'</iframe>' & @LF & _
						' ' & @LF & _
						'</body>' & @LF & _
						'</html>'

   Else
	  $IndexHtmlCode =  '<html>' & @LF & _
						'<head>' & @LF & _
						'  <title>' & $theme & ' Icons Collection</title>' & @LF & _
						'  <style type="text/css">' & @LF & _
						'    span.grey {color:lightgrey;font-family:verdana;font-size:10px}' & @LF & _
						'    span.orange {color:orange;font-weight:bold;font-family:verdana;font-size:14px}' & @LF & _
						'    span.white {color:white;font-weight:bold;font-family:verdana;font-size:20px}' & @LF & _
						'  </style>' & @LF & _
						'</head>' & @LF & _
						' ' & @LF & _
						'<span class="grey">' & @LF & _
						'  <a href="actions.html" target="iframe">actions</a> :  ' & @LF & _
						'  <a href="apps.html" target="iframe">apps</a> :  ' & @LF & _
						'  <a href="categories.html" target="iframe">categories</a> :  ' & @LF & _
						'  <a href="devices.html" target="iframe">devices</a> :  ' & @LF & _
						'  <a href="emblems.html" target="iframe">emblems</a> :  ' & @LF & _
						'  <a href="mimetypes.html" target="iframe">mimetypes</a> :  ' & @LF & _
						'  <a href="places.html" target="iframe">places</a> :  ' & @LF & _
						'  <a href="status.html" target="iframe">status</a> ' & @LF & _
						'</span>' & @LF & _
						'<p>' & @LF & _
						' ' & @LF & _
						'<body style="background-color: rgb(51, 51, 51);" bgcolor="gray" link="lightgrey" text="lightgrey" vlink="white">' & @LF & _
						' ' & @LF & _
						'<table style="width: 855px;">' & @LF & _
						'  <tbody>' & @LF & _
						'    <tr>' & @LF & _
						'      <td style="width: 250px;" align="right"><span class="grey">Icon Sizes (Pixel):  </span></td>' & @LF & _
						'      <td style="width: 16px;"><span class="grey">16</span></td>' & @LF & _
						'      <td style="width: 22px;"><span class="grey">22</span></td>' & @LF & _
						'      <td style="width: 24px;"><span class="grey">24</span></td>' & @LF & _
						'      <td style="width: 32px;"><span class="grey">32</span></td>' & @LF & _
						'      <td style="width: 48px;"><span class="grey">48</span></td>' & @LF & _
						'      <td style="width: 64px;"><span class="grey">64</span></td>' & @LF & _
						'      <td style="width: 128px;"><span class="grey">128</span></td>' & @LF & _
						'      <td style="width: 256px;"><span class="grey">256</span></td>' & @LF & _
						'    </tr>' & @LF & _
						'  </tbody>' & @LF & _
						'</table>' & @LF & _
						' ' & @LF & _
						'<iframe src="actions.html" width="100%" height="90%" name="iframe" marginheight="0" marginwidth="0" frameborder="0">' & @LF & _
						'  <p>Ihr Browser kann leider keine eingebetteten Frames anzeigen: <a href="actions.html">SELFHTML</a></p>' & @LF & _
						'</iframe>' & @LF & _
						' ' & @LF & _
						'</body>' & @LF & _
						'</html>'
   EndIf

   Return $IndexHtmlCode
EndFunc

Func code_Content_Header($cat)
   If $mode = "compare" Then
	  $ContentHeaderHtmlCode =   '<html>' & @LF & _
								 '<head>' & @LF & _
								 '  <title>' & $cat & '</title>' & @LF & _
								 '  <style type="text/css">' & @LF & _
								 '    span.grey {color:lightgrey;font-family:verdana;font-size:10px}' & @LF & _
								 '    span.orange {color:orange;font-weight:bold;font-family:verdana;font-size:14px}' & @LF & _
								 '    span.white {color:white;font-weight:bold;font-family:verdana;font-size:20px}' & @LF & _
								 '  </style>' & @LF & _
								 '</head>' & @LF & _
								 ' ' & @LF & _
								 '<body style="background-color: rgb(51, 51, 51);" bgcolor="gray" link="lightgrey" text="lightgrey" vlink="white">' & @LF & _
								 ' ' & @LF & _
								 '<table style="width: 1487px;">' & @LF & _
								 '  <tbody>' & @LF & _
								 '    <tr>' & @LF & _
								 '      <td style="width: 250px;"></td>' & @LF & _
								 '      <td style="width: 16px;"></td>' & @LF & _
								 '      <td style="width: 22px;"></td>' & @LF & _
								 '      <td style="width: 24px;"></td>' & @LF & _
								 '      <td style="width: 32px;"></td>' & @LF & _
								 '      <td style="width: 48px;"></td>' & @LF & _
								 '      <td style="width: 64px;"></td>' & @LF & _
								 '      <td style="width: 128px;"></td>' & @LF & _
								 '      <td style="width: 256px;"></td>' & @LF & _
								 '      <td style="width: 16px;"></td>' & @LF & _
								 '      <td style="width: 22px;"></td>' & @LF & _
								 '      <td style="width: 24px;"></td>' & @LF & _
								 '      <td style="width: 32px;"></td>' & @LF & _
								 '      <td style="width: 48px;"></td>' & @LF & _
								 '      <td style="width: 64px;"></td>' & @LF & _
								 '      <td style="width: 128px;"></td>' & @LF & _
								 '      <td style="width: 256px;"></td>' & @LF & _
								 '    </tr>' & @LF & _
								 ' ' & @LF & _
								 '<tr><td colspan="3"><p><span class="orange"><a name="' & $cat & '"></a>' & $cat & '</span></p></td></tr>' & @LF & _
								 ' '

   Else
	  $ContentHeaderHtmlCode =   '<html>' & @LF & _
								 '<head>' & @LF & _
								 '  <title>' & $cat & '</title>' & @LF & _
								 '  <style type="text/css">' & @LF & _
								 '    span.grey {color:lightgrey;font-family:verdana;font-size:10px}' & @LF & _
								 '    span.orange {color:orange;font-weight:bold;font-family:verdana;font-size:14px}' & @LF & _
								 '    span.white {color:white;font-weight:bold;font-family:verdana;font-size:20px}' & @LF & _
								 '  </style>' & @LF & _
								 '</head>' & @LF & _
								 ' ' & @LF & _
								 '<body style="background-color: rgb(51, 51, 51);" bgcolor="gray" link="lightgrey" text="lightgrey" vlink="white">' & @LF & _
								 ' ' & @LF & _
								 '<table style="width: 864px;">' & @LF & _
								 '  <tbody>' & @LF & _
								 '    <tr>' & @LF & _
								 '      <td style="width: 250px;"></td>' & @LF & _
								 '      <td style="width: 16px;"></td>' & @LF & _
								 '      <td style="width: 22px;"></td>' & @LF & _
								 '      <td style="width: 24px;"></td>' & @LF & _
								 '      <td style="width: 32px;"></td>' & @LF & _
								 '      <td style="width: 48px;"></td>' & @LF & _
								 '      <td style="width: 64px;"></td>' & @LF & _
								 '      <td style="width: 128px;"></td>' & @LF & _
								 '      <td style="width: 256px;"></td>' & @LF & _
								 '    </tr>' & @LF & _
								 ' ' & @LF & _
								 '<tr><td colspan="3"><p><span class="orange"><a name="' & $cat & '"></a>' & $cat & '</span></p></td></tr>' & @LF & _
								 ' '
   EndIf

   Return $ContentHeaderHtmlCode
EndFunc

Func code_Content_Bottom()
   $ContentBottomHtmlCode =   '</tbody>' & @LF & _
							  '</table>' & @LF & _
							  ' ' & @LF & _
							  '</body>' & @LF & _
							  '</html>'

   Return $ContentBottomHtmlCode
EndFunc

Func code_Content($file, $cat)
   If $mode = "compare" Then
	  $prefix = $theme & "/"
   Else
	  $prefix = ""
   EndIf

   ;Theme A
   $file_16 = @ScriptDir & "\" & $theme & "\" & $cat & "\16\" & $file & ".png"
   $file_16_svg = StringTrimRight($file_16, 3) & "svg"
   $file_22 = @ScriptDir & "\" & $theme & "\" & $cat & "\22\" & $file & ".png"
   $file_22_svg = StringTrimRight($file_22, 3) & "svg"
   $file_24 = @ScriptDir & "\" & $theme & "\" & $cat & "\24\" & $file & ".png"
   $file_24_svg = StringTrimRight($file_24, 3) & "svg"
   $file_32 = @ScriptDir & "\" & $theme & "\" & $cat & "\32\" & $file & ".png"
   $file_32_svg = StringTrimRight($file_32, 3) & "svg"
   $file_48 = @ScriptDir & "\" & $theme & "\" & $cat & "\48\" & $file & ".png"
   $file_48_svg = StringTrimRight($file_48, 3) & "svg"
   $file_64 = @ScriptDir & "\" & $theme & "\" & $cat & "\64\" & $file & ".png"
   $file_64_svg = StringTrimRight($file_64, 3) & "svg"
   $file_128 = @ScriptDir & "\" & $theme & "\" & $cat & "\128\" & $file & ".png"
   $file_128_svg = StringTrimRight($file_128, 3) & "svg"
   $file_256 = @ScriptDir & "\" & $theme & "\" & $cat & "\256\" & $file & ".png"
   $file_256_svg = StringTrimRight($file_256, 3) & "svg"

   $file_16_html = ""
   $file_22_html = ""
   $file_24_html = ""
   $file_32_html = ""
   $file_48_html = ""
   $file_64_html = ""
   $file_128_html = ""
   $file_256_html = ""

   ;image links; prefer SVG before PNG
   If FileExists($file_16_svg) Then
	  $file_16_html = '<img src="' & $prefix & $cat & "/16/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_16) Then
	  $file_16_html = '<img src="' & $prefix & $cat & "/16/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_22_svg) Then
	  $file_22_html = '<img src="' & $prefix & $cat & "/22/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_22) Then
	  $file_22_html = '<img src="' & $prefix & $cat & "/22/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_24_svg) Then
	  $file_24_html = '<img src="' & $prefix & $cat & "/24/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_24) Then
	  $file_24_html = '<img src="' & $prefix & $cat & "/24/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_32_svg) Then
	  $file_32_html = '<img src="' & $prefix & $cat & "/32/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_32) Then
	  $file_32_html = '<img src="' & $prefix & $cat & "/32/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_48_svg) Then
	  $file_48_html = '<img src="' & $prefix & $cat & "/48/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_48) Then
	  $file_48_html = '<img src="' & $prefix & $cat & "/48/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_64_svg) Then
	  $file_64_html = '<img src="' & $prefix & $cat & "/64/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_64) Then
	  $file_64_html = '<img src="' & $prefix & $cat & "/64/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_128_svg) Then
	  $file_128_html = '<img src="' & $prefix & $cat & "/128/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_128) Then
	  $file_128_html = '<img src="' & $prefix & $cat & "/128/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf

   If FileExists($file_256_svg) Then
	  $file_256_html = '<img src="' & $prefix & $cat & "/256/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
   ElseIf FileExists($file_256) Then
	  $file_256_html = '<img src="' & $prefix & $cat & "/256/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
   EndIf


   If $mode = "compare" Then ;compare mode

	  ;Theme B
	  $file_16_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\16\" & $file & ".png"
	  $file_16_svg_B = StringTrimRight($file_16_B, 3) & "svg"
	  $file_22_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\22\" & $file & ".png"
	  $file_22_svg_B = StringTrimRight($file_22_B, 3) & "svg"
	  $file_24_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\24\" & $file & ".png"
	  $file_24_svg_B = StringTrimRight($file_24_B, 3) & "svg"
	  $file_32_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\32\" & $file & ".png"
	  $file_32_svg_B = StringTrimRight($file_32_B, 3) & "svg"
	  $file_48_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\48\" & $file & ".png"
	  $file_48_svg_B = StringTrimRight($file_48_B, 3) & "svg"
	  $file_64_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\64\" & $file & ".png"
	  $file_64_svg_B = StringTrimRight($file_64_B, 3) & "svg"
	  $file_128_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\128\" & $file & ".png"
	  $file_128_svg_B = StringTrimRight($file_128_B, 3) & "svg"
	  $file_256_B = @ScriptDir & "\" & $themeB & "\" & $cat & "\256\" & $file & ".png"
	  $file_256_svg_B = StringTrimRight($file_256_B, 3) & "svg"

	  $file_16_html_B = ""
	  $file_22_html_B = ""
	  $file_24_html_B = ""
	  $file_32_html_B = ""
	  $file_48_html_B = ""
	  $file_64_html_B = ""
	  $file_128_html_B = ""
	  $file_256_html_B = ""

	  ;image links; prefer SVG before PNG
	  If FileExists($file_16_svg_B) Then
		 $file_16_html_B = '<img src="' & $themeB & "/" & $cat & "/16/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_16_B) Then
		 $file_16_html_B = '<img src="' & $themeB & "/" & $cat & "/16/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_22_svg_B) Then
		 $file_22_html_B = '<img src="' & $themeB & "/" & $cat & "/22/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_22_B) Then
		 $file_22_html_B = '<img src="' & $themeB & "/" & $cat & "/22/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_24_svg_B) Then
		 $file_24_html_B = '<img src="' & $themeB & "/" & $cat & "/24/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_24_B) Then
		 $file_24_html_B = '<img src="' & $themeB & "/" & $cat & "/24/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_32_svg_B) Then
		 $file_32_html_B = '<img src="' & $themeB & "/" & $cat & "/32/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_32_B) Then
		 $file_32_html_B = '<img src="' & $themeB & "/" & $cat & "/32/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_48_svg_B) Then
		 $file_48_html_B = '<img src="' & $themeB & "/" & $cat & "/48/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_48_B) Then
		 $file_48_html_B = '<img src="' & $themeB & "/" & $cat & "/48/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_64_svg_B) Then
		 $file_64_html_B = '<img src="' & $themeB & "/" & $cat & "/64/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_64_B) Then
		 $file_64_html_B = '<img src="' & $themeB & "/" & $cat & "/64/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_128_svg_B) Then
		 $file_128_html_B = '<img src="' & $themeB & "/" & $cat & "/128/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_128_B) Then
		 $file_128_html_B = '<img src="' & $themeB & "/" & $cat & "/128/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_256_svg_B) Then
		 $file_256_html_B = '<img src="' & $themeB & "/" & $cat & "/256/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_256_B) Then
		 $file_256_html_B = '<img src="' & $themeB & "/" & $cat & "/256/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf


	  $code_Content =   '<tr>' & @LF & _
					 '  <td valign="left"><span class="grey">- ' & file & '</span></td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_16_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_22_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_24_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_32_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_48_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_64_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_128_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_256_html & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_16_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_22_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_24_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_32_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_48_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_64_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_128_html_B & '</td>' & @LF & _
					 '  <td valign="middle">' & $file_256_html_B & '</td>' & @LF & _
					 '</tr>' & @LF


   Else ;single mode
	  $code_Content =   '<tr>' & @LF & _
					 '  <td valign="left"><span class="grey">- ' & $file & '</span></td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_16_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_22_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_24_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_32_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_48_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_64_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_128_html & '</td>' & @LF & _
					 '  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_256_html & '</td>' & @LF & _
					 '</tr>' & @LF
   EndIf


   Return $code_Content
EndFunc

Func code_Content_GC($file, $cat)
   If $mode = "compare" Then
	  $prefix = $theme & "/"
   Else
	  $prefix = ""
   EndIf

   If not FileExists(@ScriptDir & "\" & $theme & "\" & $cat & "\48\brave\" & $file & ".svg") or not FileExists(@ScriptDir & "\" & $theme & "\" & $cat & "\48\brave\" & $file & ".png") Then ;common icons
	  $code_Content = code_Content($file, $cat)

   Else ;colored icons
	  $file_16 = @ScriptDir & "\" & $theme & "\" & $cat & "\16\brave\" & $file & ".png"
	  $file_16_svg = StringTrimRight($file_16, 3) & "svg"
	  $file_22 = @ScriptDir & "\" & $theme & "\" & $cat & "\22\brave\" & $file & ".png"
	  $file_22_svg = StringTrimRight($file_22, 3) & "svg"
	  $file_24 = @ScriptDir & "\" & $theme & "\" & $cat & "\24\brave\" & $file & ".png"
	  $file_24_svg = StringTrimRight($file_24, 3) & "svg"
	  $file_32 = @ScriptDir & "\" & $theme & "\" & $cat & "\32\brave\" & $file & ".png"
	  $file_32_svg = StringTrimRight($file_32, 3) & "svg"
	  $file_48 = @ScriptDir & "\" & $theme & "\" & $cat & "\48\brave\" & $file & ".png"
	  $file_48_svg = StringTrimRight($file_48, 3) & "svg"
	  $file_64 = @ScriptDir & "\" & $theme & "\" & $cat & "\64\brave\" & $file & ".png"
	  $file_64_svg = StringTrimRight($file_64, 3) & "svg"
	  $file_128 = @ScriptDir & "\" & $theme & "\" & $cat & "\128\brave\" & $file & ".png"
	  $file_128_svg = StringTrimRight($file_128, 3) & "svg"
	  $file_256 = @ScriptDir & "\" & $theme & "\" & $cat & "\256\brave\" & $file & ".png"
	  $file_256_svg = StringTrimRight($file_256, 3) & "svg"

	  $file_16_html = ""
	  $file_22_html = ""
	  $file_24_html = ""
	  $file_32_html = ""
	  $file_48_html = ""
	  $file_64_html = ""
	  $file_128_html = ""
	  $file_256_html = ""

	  ;image links; prefer SVG before PNG
	  If FileExists($file_16_svg) Then
		 $file_16_html = '<img src="' & $prefix & $cat & "/16/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_16) Then
		 $file_16_html = '<img src="' & $prefix & $cat & "/16/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_22_svg) Then
		 $file_22_html = '<img src="' & $prefix & $cat & "/22/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_22) Then
		 $file_22_html = '<img src="' & $prefix & $cat & "/22/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_24_svg) Then
		 $file_24_html = '<img src="' & $prefix & $cat & "/24/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_24) Then
		 $file_24_html = '<img src="' & $prefix & $cat & "/24/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_32_svg) Then
		 $file_32_html = '<img src="' & $prefix & $cat & "/32/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_32) Then
		 $file_32_html = '<img src="' & $prefix & $cat & "/32/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_48_svg) Then
		 $file_48_html = '<img src="' & $prefix & $cat & "/48/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_48) Then
		 $file_48_html = '<img src="' & $prefix & $cat & "/48/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_64_svg) Then
		 $file_64_html = '<img src="' & $prefix & $cat & "/64/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_64) Then
		 $file_64_html = '<img src="' & $prefix & $cat & "/64/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_128_svg) Then
		 $file_128_html = '<img src="' & $prefix & $cat & "/128/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_128) Then
		 $file_128_html = '<img src="' & $prefix & $cat & "/128/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf

	  If FileExists($file_256_svg) Then
		 $file_256_html = '<img src="' & $prefix & $cat & "/256/brave/" & $file & ".svg" & '" style="border-style: none;" align="absmiddle">'
	  ElseIf FileExists($file_256) Then
		 $file_256_html = '<img src="' & $prefix & $cat & "/256/brave/" & $file & ".png" & '" style="border-style: none;" align="absmiddle">'
	  EndIf


	  $code_Content =   '<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(brave)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_16_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_22_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_24_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_32_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_48_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_64_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_128_html & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & $file_256_html & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(carbonite)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/carbonite/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(dust)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/dust/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(human)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/human/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/human/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(illustrious)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/illustrious/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(noble)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/noble/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(tribute)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/tribute/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(wine)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/wine/") & '</td>' & @LF & _
						'</tr>' & @LF & _
						'<tr>' & @LF & _
						'  <td valign="left"><span class="grey">- ' & $file & '(wise)</span></td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_16_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_22_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_24_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_32_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_48_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_64_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_128_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'  <td valign="middle" style="background-color: rgb(102, 102, 102);">' & StringReplace($file_256_html, "/brave/", "/wise/") & '</td>' & @LF & _
						'</tr>' & @LF

   EndIf

   Return $code_Content
EndFunc

#EndRegion


;=========================================================================================================
; Function Name:   _RecursiveFileListToArray($sPath, $sPattern, $iFlag = 0, $iFormat = 1, $sDelim = @CRLF)
; Description::    gibt Verzeichnisse und/oder Dateien (rekursiv) zurück, die
;                  einem RegExp-Pattern entsprechen
; Parameter(s):    $sPath = Startverzeichnis
;                  $sPattern = ein beliebiges RexExp-Pattern für die Auswahl
;                  $iFlag = Auswahl
;                           0 = Dateien & Verzeichnisse
;                           1 = nur Dateien
;                           2 = nur Verzeichnisse
;                  $iFormat = Rückgabeformat
;                             0 = String
;                             1 = Array mit [0] = Anzahl
;                             2 = Nullbasiertes Array
;                  $sDelim = Trennzeichen für die String-Rückgabe
; Requirement(s):  AutoIt 3.3.0.0
; Return Value(s): Array/String mit den gefundenen Dateien/Verzeichnissen
; Author(s):       Oscar (www.autoit.de)
;                  Anregungen von: bernd670 (www.autoit.de)
;=========================================================================================================
;Quelle: http://www.autoit.de/index.php?page=Thread&threadID=12423&highlight=_RecursiveFileListToArray
Func _RecursiveFileListToArray($sPath, $sPattern, $iFlag = 0, $iFormat = 1, $sDelim = @CRLF)
    Local $hSearch, $sFile, $sReturn = ''
    If StringRight($sPath, 1) <> '\' Then $sPath &= '\'
    $hSearch = FileFindFirstFile($sPath & '*.*')
    If @error Or $hSearch = -1 Then Return SetError(1, 0, $sReturn)
    While True
        $sFile = FileFindNextFile($hSearch)
        If @error Then ExitLoop
        If StringInStr(FileGetAttrib($sPath & $sFile), 'D') Then
            If StringRegExp($sPath & $sFile, $sPattern) And ($iFlag = 0 Or $iFlag = 2) Then $sReturn &= $sPath & $sFile & '\' & $sDelim
            $sReturn &= _RecursiveFileListToArray($sPath & $sFile & '\', $sPattern, $iFlag, 0)
            ContinueLoop
        EndIf
        If StringRegExp($sFile, $sPattern) And ($iFlag = 0 Or $iFlag = 1) Then $sReturn &= StringTrimRight($sFile, 4) & $sDelim ;$sPath & $sFile & $sDelim
    WEnd
    FileClose($hSearch)
    If $iFormat Then Return StringSplit(StringTrimRight($sReturn, StringLen($sDelim)), $sDelim, $iFormat)

    Return $sReturn
 EndFunc
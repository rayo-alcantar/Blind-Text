#include <FileConstants.au3>
#include <guiConstantsEx.au3>
#include <msgBoxConstants.au3>

global $cph_ver = "2021.11.2.0"
func cphistory()
speaking(translate($idioma, "Loading..."))
Global $rfile = FileReadToArray("config\cliphistory.btx")
$Contarlineas = @extended
If @error Then MsgBox($MB_SYSTEMMODAL, translate($idioma, "error"), translate($idioma, "An error occurred when reading the file."))
global $hstgui = GUICreate(translate($idioma, "Clipboard history"))
$idCliplabel = GUICtrlCreateLabel("List of entries: " &$contarlineas &"total entries", 20, 40, 100, 20)
Global $idcplist1 = GUICtrlCreateList("", 20, 90, 300, 20)
;GUICtrlSetLimit(-1, 500)
Global $idSavetofile = GUICtrlCreateButton(translate($idioma, "Save selected text to file"), 85, 40, 80, 20)
GuiCtrlSetOnEvent(-1, "htshanddler")
Global $idSpeakselected = GUICtrlCreateButton(translate($idioma, "&Speak the selected entry"), 85, 110, 80, 20)
GuiCtrlSetOnEvent(-1, "htshanddler")
Global $idCopy = GUICtrlCreateButton(translate($idioma, "&Copy the selected entry"), 85, 160, 80, 20)
GuiCtrlSetOnEvent(-1, "htshanddler")
Global $idClosehst = GUICtrlCreateButton(translate($idioma, "&Close"), 150, 40, 100, 20)
GuiCtrlSetOnEvent(-1, "closehst")
For $I = 0 To $contarlineas - 1
GUICtrlSetData($idcplist1, $rfile[$I])
sleep(10)
Next
speaking("Loaded")
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "closehst")
EndFunc
Func htshanddler()
global $readlist = GUICtrlRead($idCplist1)
select
Case @GUI_CtrlId = $idSavetofile
global $savefile = FileSaveDialog("Save current history entry as", "", "text file (*.txt)|log file (*.log)|MarkDown file (*.md)|HTML file (*.html)", $FD_FILEMUSTEXIST)
if $savefile = "" then MSGBox(16, "Error", "You have not selected any file name to save")
select
case StringInStr($savefile, ".txt")
WriteText("txt")
case StringInStr($savefile, ".log")
WriteText("log")
case StringInStr($savefile, ".md")
WriteText("md")
case StringInStr($savefile, ".html")
WriteText("html")
EndSelect
Case @GUI_CtrlId = $idSpeakselected
speaking($readlist)
Case @GUI_CtrlId = $idCopy
if not ClipPut($readlist) = 0 then
speaking("The text has been copied to the clipboard")
Else
speaking("An error occurred while sending text")
EndIf
EndSelect
EndFunc
Func closehst()
GUIDelete($hstgui)
EndFunc
Func WriteText($format)
$FileToWrite = FileOpen($savefile, 1)
select
Case $format = "txt"
FileWrite($FileToWrite, "Contents of my clipboard history:" &@crlf &$readlist)
Case $format = "log"
FileWriteLine($FileToWrite, "start " &@MDAY &"/" &@MON &"/" &@YEAR &"," &@HOUR &":" &@MIN &":" &@SEC)
FileWriteLine($FileToWrite, @YEAR & "-" &@MON & "-" &@MDAY & " " &@HOUR & ":" &@MIN & ": " &"Log generated by Blind Text")
FileWriteLine($FileToWrite, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ": " &"Version: " &$program_ver)
FileWriteLine($FileToWrite, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ": " &"clipTools version: " &$cpt_ver)
FileWriteLine($FileToWrite, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ": " &"ClipHistory dependency version: " &$cph_ver)
FileWriteLine($FileToWrite, @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ": " &"Clipboard History Contents: " &$readlist)
Case $format = "md"
FileWrite($FileToWrite, "# Clipboard history" &@crlf &@crlf &"Document generated by BlindText" &@crlf &@crlf &"---" &@crlf &"Version: " &$program_Ver &@crlf &@CRLF &"## Clipboard contents:" &@crlf &@crlf &"> " &$readlist &@crlf &@crlf &"## COPYRIGHT" &@crlf &@crlf &"©(C) 2019-2021 MT programs")
Case $format = "html"
FileWrite($FileToWrite, "<html>" &@crlf &"<head>" &@crlf &"<title> " &$programName &" </title>" &@crlf &"</head>" &@crlf &"<hr>" &@crlf &"<p>" &@crlf &"Document generated by blind Text " &$program_ver &@crlf &"</p>" &@crlf &"<h1>" &@crlf &"Clipboard contents" &@crlf &"</h1>" &@crlf &"<blockquote>" &@crlf &"<p>" &$readlist &"</p>" &@crlf &"</blockquote>" &@crlf &"<hr>" &@crlf &"<b><u><i> ©(C) 2019-2021 MT programs</i></u></b>" &@crlf &"</html>" &@crlf)
EndSelect
EndFunc
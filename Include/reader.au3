;#include "kbc.au3"
#include-once
#include "log.au3"
#include "jfw.au3"
#include "NVDAControllerClient.au3"
#include "sapi.au3"
;este es un script para los lectores de pantalla. this is a script for screen readers.
;Author: Mateo Cedillo.
Func speaking($text)
$speak = IniRead(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "")
Select
Case $speak = "NVDA"
_nvdaControllerClient_Load()
If @error Then
MsgBox(16, "error", "cant load the NVDA DLL file")
Exit
Else
;_NVDAControllerClient_CancelSpeech()
_NVDAControllerClient_SpeakText($text)
_NVDAControllerClient_BrailleMessage($text)
EndIf
Case $speak = "Sapi"
speak($text, 3)
Case $speak = "JAWS"
JFWSpeak($text)
Case Else
autodetect()
EndSelect
EndFunc   ;==>speaking
Func autodetect()
If ProcessExists("NVDA.exe") Then
IniWrite(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "NVDA")
EndIf
If ProcessExists("JFW.exe") Then
IniWrite(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "JAWS")
EndIf
If Not ProcessExists("NVDA.exe") Or ProcessExists("JFW.exe") Then
IniWrite(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "Sapi")
EndIf
EndFunc   ;==>autodetect
Func TTsDialog($text, $ttsString = " press enter to continue, space to repeat information.")
$pressed = 0
$repeatinfo = 0
If ProcessExists("NVDA.exe") Then
_NVDAControllerClient_CancelSpeech()
EndIf
speaking($text & @LF & $ttsString)
While 1
$active_window = WinGetProcess("")
If $active_window = @AutoItPID Then
If Not _IsPressed($spacebar) Or Not _IsPressed($up) Or Not _IsPressed($down) Or Not _IsPressed($left) Or Not _IsPressed($right) Then $repeatinfo = 0
If _IsPressed($spacebar) Or _IsPressed($up) Or _IsPressed($down) Or _IsPressed($left) Or _IsPressed($right) And $repeatinfo = 0 Then
$repeatinfo = 1
speaking($text & @LF & $ttsString)
EndIf
If Not _IsPressed($control) And _IsPressed($c) Then $pressed = 0
If _IsPressed($control) And _IsPressed($c) And $pressed = 0 Then
ClipPut($text)
speaking($text & "Copied to clipboard.")
EndIf
If Not _IsPressed($enter) Then $pressed = 0
If _IsPressed($enter) And $pressed = 0 Then
$pressed = 1
speaking("ok")
ExitLoop
EndIf
EndIf
Sleep(50)
WEnd
EndFunc   ;==>TTsDialog
Func createTtsOutput($filetoread, $title)
$move_doc = 0
Local $r_file = FileReadToArray($filetoread)
Local $iCountLines = @extended
$not = 0
$docError=0
$selectionmode = 0
local $textselected=""
If @error Then
speaking("Error reading file...")
writeinlog("error reading file...")
$DocError=1
Else
speaking($title)
writeinlog("Dialog: " & $title)
writeinlog("file: " & $filetoread)
writeinlog("File information: Lines: " & $iCountLines)
EndIf
While 1
if $DocError=1 then exitLoop
$active_window = WinGetProcess("")
If $active_window = @AutoItPID Then
Else
Sleep(10)
ContinueLoop
EndIf
If Not _IsPressed($shift) And _IsPressed($down) Then $not = 1
If Not _IsPressed($shift) And _IsPressed($up) Then $not = 1
If _IsPressed($home) then
If $selectionmode=1 then
if not $textselected = "" then
Speaking("Unselected")
$textselected = ""
EndIf
EndIF
$move_doc = "0"
speaking($r_file[$move_doc])
writeinlog($move_doc)
While _IsPressed($home)
Sleep(100)
WEnd
EndIf
If _IsPressed($page_down) Then
$move_doc = $move_doc +10
if $move_doc >= $iCountLines then
$move_doc = $iCountLines -1
speaking("document end. Press enter to back.")
EndIF
speaking($r_file[$move_doc])
writeinlog($move_doc)
While _IsPressed($page_down)
Sleep(100)
WEnd
EndIf
If _IsPressed($page_up) Then
$move_doc = $move_doc -10
if $move_doc <= 0 then $move_doc="0"
speaking($r_file[$move_doc])
writeinlog($move_doc)
While _IsPressed($page_up)
Sleep(100)
WEnd
EndIf
If _IsPressed($end) Then
If $selectionmode = 1 then
if not $textselected = "" then
Speaking("Unselected")
$textselected = ""
EndIf
EndIf
$move_doc = $iCountLines -1
speaking($r_file[$move_doc] &@crlf &"document end. Press enter to back.")
writeinlog($move_doc)
While _IsPressed($end)
Sleep(100)
WEnd
EndIf
If _IsPressed($up) Then
$move_doc = $move_doc - 1
if $move_doc <= 0 then
If $selectionmode=1 then speaking("You have reached the home of the document, there is nothing else to select.")
$move_doc="0"
EndIf
If $selectionmode=1 then 
$textselected &= $r_file[$move_doc] &@crlf
speaking("Was selected " &$r_file[$move_doc])
Else
speaking($r_file[$move_doc])
writeinlog($move_doc)
EndIf
While _IsPressed($up)
if $selectionmode = 1 then beep(4000, 50)
Sleep(100)
WEnd
EndIf
If _IsPressed($down) then
$move_doc = $move_doc +1
if $move_doc >= $iCountLines then
If $selectionmode=1 then speaking("You have reached the end of the document, there is nothing else to select.")
speaking("document end. Press enter to back.")
$move_doc=$iCountLines -1
EndIF
If $selectionmode = 1 then
$textselected &= $r_file[$move_doc] &@crlf
speaking("Was selected " &$r_file[$move_doc])
else
speaking($r_file[$move_doc])
writeinlog($move_doc)
EndIf
While _IsPressed($down)
If $selectionmode = 1 then beep(4000, 50)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($c) then
if $textSelected = "" then
Speaking("You have not selected text to copy!")
Else
ClipPut($textselected)
Speaking("the text has been copied to that clipboard")
if $selectionmode=1 then $selectionmode=0
EndIf
While _IsPressed($control) And _IsPressed($c)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($a) Then
speaking("Selecting all...")
for $selecting = 0 to $iCountLines - 1
$textselected = $r_file[$selecting]
Next
Speaking("All text was selected")
if $selectionmode=1 then $selectionmode=0
While _IsPressed($control) And _IsPressed($a)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($shift) And _IsPressed($s) Then
if not $selectionmode = 0 then
Speaking("He left the selection mode")
$selectionmode=0
Else
speaking("Entered to the selection mode")
$selectionmode=1
EndIf
While _IsPressed($control) And _IsPressed($shift) And _IsPressed($s)
Sleep(100)
WEnd
EndIf
If _IsPressed($enter) Then
return $move_doc
$not = 0
ExitLoop
EndIf
Sleep(10)
WEnd
EndFunc   ;==>createTtsOutput
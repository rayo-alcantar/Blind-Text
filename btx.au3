#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=N
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Description=Blind Text
#AutoIt3Wrapper_Res_Fileversion=0.2.0.0
;#AutoIt3Wrapper_Res_Fileversion_Use_Template=%YYYY.%MO.%DD.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
;#AutoIt3Wrapper_Res_Fileversion_First_Increment=y
#AutoIt3Wrapper_Res_ProductName=Blind Text
#AutoIt3Wrapper_Res_ProductVersion=0.2.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2021 MT Programs, All rights reserved
#AutoIt3Wrapper_Res_Language=12298
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -v1 -v2 -v3
#AutoIt3Wrapper_Run_Tidy=n
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
;#AutoIt3Wrapper_Versioning=v
#AutoIt3Wrapper_Run_Before="%scriptdir%\buildsounds.bat"
#AutoIt3Wrapper_Run_After="%scriptdir%\encrypter-auto.exe"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Btx
;By Mateo Cedillo
;This little program is a suite of utilities with various tools and functions.
#pragma compile(Out, BlindText.exe)
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(UPX, False)
;#pragma compile(Compression, 2)
#pragma compile(inputboxres, false)
#pragma compile(FileDescription, Blind Text)
#pragma compile(ProductName, Blind Text)
#pragma compile(ProductVersion, 0.2.0.0)
#pragma compile(Fileversion, 0.2.0.20)
#pragma compile(InternalName, "mateocedillo.BTX")
#pragma compile(LegalCopyright, © 2018-2021 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
#pragma compile(OriginalFilename, BlindText.exe)
global $programname="Blind text"
global $program_ver = "0.2"
global $cpt_ver = "2021.11.5.0"
$idioma = iniRead ("config\config.st", "General settings", "language", "")
;Include
#include "include\audio.au3"
#include <AutoItConstants.au3>
#include "include\cliphistory.au3"
#include <ComboConstants.au3>
#include <EditConstants.au3>
#Include <fileConstants.au3>
#include <guiConstantsEx.au3>
#include <InetConstants.au3>
#include <include\kbc.au3>
#include <include\menu_nvda.au3>
#include <misc.au3>
#include <include\NVDAControllerClient.au3>
#include "include\options.au3"
#include "include\progress.au3"
#include <include\reader.au3>
#include <include\sapi.au3>
#include "include\share.au3"
#include <SliderConstants.au3>
#include "include\Sintesizer-comaudio.au3"
#include "include\translator.au3"
#include "updater.au3"
#include "include\Utter.au3"
#include "include\voiceDownloader.au3"
#include <WindowsConstants.au3>
#include "include\zip.au3"
Opt("GUIOnEventMode",1)
$l1 = GUICreate(translate($idioma, "Loading..."))
GUISetState(@SW_SHOW)
global $ifitisupdate = IniRead("Config\config.st", "General settings", "Check updates", "")
If $ifitisupdate = "" then
IniWrite("Config\config.st", "General settings", "Check updates", "Yes")
$ifitisupdate = "yes"
EndIF
global $enablehst = IniRead("Config\config.st", "Clipboard settings", "Enable clipboard history", "")
If $enablehst = "" then
IniWrite("Config\config.st", "Clipboard settings", "Enable clipboard history", "Yes")
$enablehst = "yes"
else
EndIF
global $soundclose = $device.opensound ("sounds/close.ogg", true)
global $errorsound = $device.opensound ("sounds/error.ogg", true)
global $open = $device.opensound ("sounds/open.ogg", true)
global $radiosound = $device.opensound ("sounds/radio.ogg", true)
global $enableClip = 0
global $enableVoice = 0
global $oldtext = ""
Global $cliptext = ""
sleep(10)
If FileExists("BTXExtract.exe") then
$readinst = iniRead("config\config.st", "update", "Pending installation", "")
select
case $readinst = ""
IniWrite("Config\config.st", "Update", "Pending installation", "not completed")
pendingInstallation()
case else
FileDelete("BTXExtract.exe")
endselect
EndIf
If not FileExists("BTX.au3") Then
Extractor()
else
comprovar()
endif
func pendinginstallation()
$ifinstallation = iniRead("config\config.st", "update", "Pending installation", "")
if $ifinstallation = "not completed" then
$questupd = msgBox(4, translate($idioma, "pending update"), translate($idioma, "there is a pending update. Do you want to install it right now?"))
If $questupd = 6 Then
IniWrite("Config\config.st", "Update", "Pending installation", "completed")
ShellExecute("BTXExtract.exe")
if @error then
MSgBox(16, "Error", "Can't run the update package! I think you have to download the program manually.")
exitpersonaliced()
else
EndIf
endIF
else
FileDelete("BTXExtract.exe")
EndIf
EndFunc
Func Extractor()
If FileExists("sounds\*.ogg") then
if @compiled then
msgbox (4096, translate($idioma, "error"), translate($idioma, "Damn thief, stop stealing the sounds!"))
exit
EndIf
comprovar()
endif
If FileExists(@TempDir &"\sounds\*.ogg") then
if @compiled then
;remover esa carpeta
DirRemove(@TempDir & "/sounds", 1)
EndIf
endIf
comprovar()
sleep(50)
GUIDelete($l1)
comprovar()
GUIDelete($l1)
EndFunc
func comprovar()
if not fileExists ("config") then DirCreate("config")
GUIDelete($l1)
;if @OSArch = "x64" and @AutoItX64 = 0 then
;msgBox(48, Translate($idioma, "Warning"), Translate($idioma, "You run a 64-bit pc with the 32-bit version of the program. "&@crlf &"For better performance in the program, we recommend that you download the 64-bit version at http://mateocedillo.260mb.net/programs.html"))
;exitpersonaliced()
;endif
;if @OSArch = "x86" and @AutoItX64 = 1 then
;msgBox(48, Translate($idioma, "Warning"), Translate($idioma, "You run a 32-bit pc with the 64-bit version of the program." &@crlf &"For better performance in the program, we recommend that you download the 32-bit version at http://mateocedillo.260mb.net/programs.html"))
;exitpersonaliced()
;endif
checkselector()
EndFunc
func checkselector()
global $idioma = iniRead ("config\config.st", "General settings", "language", "")
select
case $idioma =""
selector()
case else
checkupd()
endselect
endfunc
Func Selector()
local $widthCell,$msg,$iOldOpt
global $langGUI= GUICreate("Language Selection")
global $seleccionado="0"
$widthCell=70
$iOldOpt=Opt("GUICoordMode",$iOldOpt)
$beep = "0"
$busqueda = "0"
dim $langcodes[50]
GUICtrlCreateLabel("Select language:", -1,0)
GUISetBkColor(0x00E0FFFF)
$recolectalosidiomasporfavor = FileFindFirstFile("lng\*.lang")
If $recolectalosidiomasporfavor = -1 Then MsgBox(16, "Fatal error", "We cannot find the language files. Please download the program again...")
Local $Recoleccion = "", $obteniendo = ""
While 1
$beep = $Beep +1
$busqueda = $busqueda +1
$Recoleccion = FileFindNextFile($recolectalosidiomasporfavor)
If @error Then
;MsgBox(16, "Error", "We cannot find the language files or they are corrupted.")
CreateAudioProgress("100")
ExitLoop
EndIf
$splitCode = StringLeft($Recoleccion, 2)
$obteniendo &= GetLanguageName($splitCode) &", " &GetLanguageCode($splitCode) &"|"
$langcodes[$busqueda] = GetLanguageCode($splitcode)
;MSGBox(0, "debug", $langcodes[$busqueda])
CreateAudioProgress($beep)
Sleep(100)
WEnd
$langcount = StringSplit($obteniendo, "|")
global $Choose = GUICtrlCreateCombo("", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GuiCtrlSetOnEvent(-1, "seleccionar")
GUICtrlSetData($Choose, $obteniendo)
global $idBtn_OK = GUICtrlCreateButton("OK", 155, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "save")
global $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "exitpersonaliced")
GUISetState(@SW_SHOW)
Global $LEER = ""
while 1
if $seleccionado="1" then
;msgbox(0, "Correct", "We should close this.")
exitloop
EndIf
Wend
GUIDelete($langGui)
checkupd()
endFunc
func seleccionar()
global $leer = GUICtrlRead($choose)
global $queidiomaes = StringSplit($leer, ",")
;speaking("Has seleccionado " &StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
EndFunc
func save()
IniWrite("config\config.st", "General settings", "language", StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
$seleccionado="1"
EndFunc
func checkupd()
global $main_u = GUICreate(translate($idioma, "Checking version..."))
GUISetState(@SW_SHOW)
toolTip(translate($idioma, "checking version..."))
if $ifitisupdate = "Yes" then
checkversion()
else
Principal()
EndIF
sleep(50)
GUIDelete($main_u)
sleep(50)
endfunc
func checkversion()
Local $yourexeversion = $program_ver
$fileinfo = InetGet("https://www.dropbox.com/s/gnwirlzugplx4ss/BTXWeb.dat?dl=1", @tempDir &"\BTXWeb.dat")
$latestver = iniRead (@TempDir & "\BTXWeb.dat", "updater", "LatestVersion", "")
select
Case $latestVer > $yourexeversion
TTSDialog(translate($idioma, "Update available!") &" " &translate($idioma, "You have the version") &$yourexeversion &translate($idioma, "and is available the") &$latestver, translate($idioma, " press enter to continue, space to repeat information."))
sleep(50)
GUIDelete($main_u)
_Updater_Update("BTX.exe", "none", "https://www.dropbox.com/s/tnldmdkn58kdwfa/BTXExtract.exe?dl=1")
Case else
GUIDelete($main_u)
checkmotd()
endselect
InetClose($fileinfo)
GUIDelete($main_u)
endfunc
func checkmotd()
;Function to check messaje of the day.
$LMotd = iniRead ("config\config.st", "misc", "motdversion", "")
$LatestMotd = iniRead (@TempDir & "\BTXWeb.dat", "motd", "Latest", "")
select
Case $latestMotd > $lMotd
motdprincipal()
Case $latestMotd = $lMotd
principal()
endselect
endfunc
func motdprincipal()
$LatestMotd = iniRead (@TempDir & "\BTXWeb.dat", "motd", "Latest", "")
$downloadingmotd = GUICreate(translate($idioma, "Downloading message of the day..."))
GUICtrlCreateLabel(translate($idioma, "Please wait."), 85, 20)
GUISetState(@SW_SHOW)
Sleep(10)
$M_mode = iniRead (@TempDir & "\BTXWeb.dat", "motd", "Mode", "")
$ok = iniWrite ("config\config.st", "misc", "motdversion", $LatestMotd)
select
case $idioma ="es"
$M_text = iniRead (@TempDir & "\BTXWeb.dat", "motd", "Text1", "")
TTSDialog($m_text, translate($idioma, " press enter to continue, space to repeat information."))
case $idioma ="en"
$M_text = iniRead (@TempDir & "\BTXWeb.dat", "motd", "Text2", "")
TTSDialog($m_text, translate($idioma, " press enter to continue, space to repeat information."))
endselect
GUIDelete($downloadingmotd)
If @Compiled Then
FileDelete(@tempDir & "\MCWeb.dat")
EndIf
PRINCIPAL()
endfunc
Func principal()
ToolTip("")
if @compiled then FileDelete(@tempDir &"\BTXWeb.dat")
$idioma = iniRead ("config\config.st", "General settings", "language", "")
$open.play
global $Gui_main = guicreate("Blind text! " &$program_ver)
HotKeySet("{F1}", "playhelp")
Local $idmainmenu = GUICtrlCreateMenu($programname)
Local $idOptionsitem = GUICtrlCreateMenuItem(translate($idioma, "Options..."), $idmainmenu)
GUICtrlSetOnEvent(-1, "Options")
Local $idExititem = GUICtrlCreateMenuItem(translate($idioma, "Exit"), $idmainmenu)
GUICtrlSetOnEvent(-1, "exitpersonaliced")
Local $idmen1 = GUICtrlCreateMenu(translate($idioma, "Clipboard"))
Global $idClip = GUICtrlCreateMenuItem(translate($idioma, "Read in loud voice..."), $idmen1)
GUICtrlSetOnEvent(-1, "Readclip")
Global $idClip = GUICtrlCreateMenuItem(translate($idioma, "Read in dialogue mode"), $idmen1)
GUICtrlSetOnEvent(-1, "Readasdialogue")
Global $idWriteToClip = GUICtrlCreateMenuItem(translate($idioma, "Send data"), $idmen1)
GUICtrlSetOnEvent(-1, "SendData")
global $idMonitor = GUICtrlCreateMenuItem(translate($idioma, "Monitor clipboard"), $idmen1)
GUICtrlSetOnEvent(-1, "monitorEnable")
Global $idMonitor2 = GUICtrlCreateMenuItem(translate($idioma, "Monitor clipboard with a independent voice"), $idmen1)
GUICtrlSetOnEvent(-1, "monitorEnable2")
Global $idHTS = GUICtrlCreateMenuItem(translate($idioma, "History"), $idmen1)
GUICtrlSetOnEvent(-1, "cphistory")
Global $idClip = GUICtrlCreateMenuItem(translate($idioma, "Read history in document mode"), $idmen1)
GUICtrlSetOnEvent(-1, "Readasdocument")
Local $idmen2 = GUICtrlCreateMenu(translate($idioma, "Writting and reading"))
Local $idmen21 = GUICtrlCreateMenu(translate($idioma, "Read mode"), $idmen2)
Global $idreadmanual = GUICtrlCreateMenuItem(translate($idioma, "Read in document mode"), $idmen21)
GUICtrlSetOnEvent(-1, "readdocumentmanual")
Global $idreadAudio = GUICtrlCreateMenuItem(translate($idioma, "Read in audio mode"), $idmen21)
GUICtrlSetOnEvent(-1, "readinaudio")
Global $idreadOther = GUICtrlCreateMenuItem(translate($idioma, "Read with an independent voice"), $idmen21)
GUICtrlSetOnEvent(-1, "readinvoice")
;Local $idmen22 = GUICtrlCreateMenu(translate($idioma, "Write"), $idmen2)
;Global $idWritenew = GUICtrlCreateMenuItem(translate($idioma, "Write a new file..."), $idmen22)
;GUICtrlSetOnEvent(-1, "Writefile")
;Global $idEdit = GUICtrlCreateMenuItem(translate($idioma, "edit file..."), $idmen22)
;GUICtrlSetOnEvent(-1, "Editfile")
Local $idHelpmenu = GUICtrlCreateMenu(translate($idioma, "Help"))
Local $idHelpitema = GUICtrlCreateMenuItem(translate($idioma, "About..."), $idHelpmenu)
GUICtrlSetOnEvent(-1, "ayuda")
Local $idHelpitemb = GUICtrlCreateMenuItem(translate($idioma, "Visit website"), $idHelpmenu)
GUICtrlSetOnEvent(-1, "WEBSITE")
Local $idHelpitemc = GUICtrlCreateMenuItem(translate($idioma, "&User manual"), $idHelpmenu)
GUICtrlSetOnEvent(-1, "Playhelp")
Local $idChanges = GUICtrlCreateMenuItem(translate($idioma, "Changes"), $idHelpmenu)
GUICtrlSetOnEvent(-1, "readchanges2")
local $idBGR = GUICtrlCreateMenuItem(translate($idioma, "Errors and suggestions"), $idHelpmenu)
GUICtrlSetOnEvent(-1, "Report")
local $idBGR = GUICtrlCreateMenuItem(translate($idioma, "Errors and suggestions (GitHub)"), $idHelpmenu)
GUICtrlSetOnEvent(-1, "newIssue")
GUICtrlCreateLabel(translate($idioma, "Open the menu or explore the following options:"), 20, 50)
GUICtrlSetState(-1, $GUI_FOCUS)
Local $idMenubtn = GUICtrlCreateButton(translate($idioma, "Open menu"), 20, 50 + (1 * 40), 100, 30)
GuiCtrlSetOnEvent(-1, "openmenu")
Local $idManualbutton = GUICtrlCreateButton(translate($idioma, "&User manual"), 20, 50 + (2 * 40), 100, 30)
GuiCtrlSetOnEvent(-1, "playhelp")
Local $idChangesbutton = GUICtrlCreateButton(translate($idioma, "Changes"), 20, 50 + (3 * 40), 100, 30)
GuiCtrlSetOnEvent(-1, "readchanges2")
Local $idGithubBTN = GUICtrlCreateButton("Github", 20, 50 + (4 * 40), 100, 30)
GuiCtrlSetOnEvent(-1, "github")
Local $idShareBTN = GUICtrlCreateButton(translate($idioma, "Share"), 20, 50 + (5 * 40), 100, 30) ;New button
GuiCtrlSetOnEvent(-1, "Shareapp")
Local $idExitbutton = GUICtrlCreateButton(translate($idioma, "E&xit"), 20, 50 + (6 * 40), 100, 30)
GuiCtrlSetOnEvent(-1, "exitpersonaliced")
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "exitpersonaliced")
While 1
if $enableClip = 1 then
$oldtext = $cliptext
$cliptext = clipget()
if $cliptext <> $oldtext then
if $enablehst = "yes" then $FileHistory = FileOpen(@scriptdir & "\config\Cliphistory.btx", 1)
if stringLen($cliptext) > 3000 then
if $enableVoice = 1 then
HablarEnLetras("Es_default", "es_default", Translate($idioma, "The clipboard text is more than three thousand characters."))
Else
speaking(Translate($idioma, "The clipboard text is more than three thousand characters."))
EndIf
else
If $enableVoice = 1 then
HablarEnLetras("Es_default", $cliptext)
else
speaking($cliptext)
EndIf
EndIf
if $enablehst = "yes" then
FileWriteLine($fileHistory, $cliptext)
FileClose($fileHistory)
EndIf
EndIf
If _IsPressed($control) And _IsPressed($z) then
speaking(translate($idioma, "undo"))
While _IsPressed($control) And _IsPressed($z)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($x) Then
speaking(translate($idioma, "It was cut") &" " &$Cliptext)
While _IsPressed($control) And _IsPressed($x)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($c) Then
speaking(translate($idioma, "was copied") &" " &$Cliptext)
While _IsPressed($control) And _IsPressed($c)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($v) Then
speaking(translate($idioma, "has been pasted") &" " &$Cliptext & "from clipboard")
While _IsPressed($control) And _IsPressed($v)
Sleep(100)
WEnd
EndIf
If _IsPressed($control) And _IsPressed($a) Then
if stringLen($cliptext) > 3000 then
speaking(Translate($idioma, "All text has been selected"))
else
speaking(translate($idioma, "Selected") &" " &$cliptext)
EndIf
While _IsPressed($control) And _IsPressed($a)
Sleep(100)
WEnd
EndIF
If _IsPressed($control) And _IsPressed($y) Then
speaking(translate($idioma, "Redo"))
While _IsPressed($control) And _IsPressed($y)
Sleep(100)
WEnd
EndIf
sleep(100)
else
ContinueLoop
EndIf
WEnd
EndFunc
func openmenu()
Send("{alt}")
EndFunc
func github()
ShellExecute("https://github.com/rmcpantoja/")
If @error then MsgBox(16, "Error", "Cannot run browser. It is likely that you have to add an association.")
EndFunc
Func Website()
ShellExecute("http://mateocedillo.260mb.net/")
If @error then MsgBox(16, "Error", "Cannot run browser. It is likely that you have to add an association.")
EndFunc
func shareapp()
$shareresult = share(translate($idioma, "I share with you the blind text (beta) program for the blind where you can have access to a variety of tools for word processing, such as reading and writing."), "http://mateocedillo.260mb.net/BTX.zip")
;If $shareresult = 0 then MsgBox(16, Translate($idioma, "error"), translate($idioma, "Sharing failed."))
EndFunc
Func ayuda()
MsgBox(0, translate($idioma, "About..."), $programname &", " &translate($idioma, "Version") &" " &$program_ver &", " &translate($idioma, "Blind text, text tools and utilities for the blind people. 2018-2021 MT programs."))
EndFunc
func playhelp()
Local $manualdoc = "documentation\" &$idioma &"\manual.txt"
global $DocOpen = FileOpen($manualdoc, $FO_READ)
speaking(translate($idioma, "Opening..."))
ToolTip(translate($idioma, "Opening..."))
sleep(50)
If $DocOpen = -1 Then MsgBox($MB_SYSTEMMODAL, translate($idioma, "error"), translate($idioma, "An error occurred when reading the file."))
Local $openned = FileRead($DocOpen)
ToolTip("")
global $manualwindow = GUICreate(translate($idioma, "User manual"))
Local $idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
Local $idExitBtn2 = GUICtrlCreateButton(translate($idioma, "Close"), 100, 370, 150, 30)
GuiCtrlSetOnEvent(-1, "delete")
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "delete")
EndFunc
func delete()
FileClose($DocOpen)
GUIDelete($manualwindow)
EndFunc
func exitpersonaliced()
;This custom exit function is used to delete some files when exiting the program. 0 for disabled, 1 enabled (by default it is disabled for all general users).
_nvdaControllerClient_free()
$delfiles = "1"
$soundclose.play
sleep(1000)
select
case $delfiles = 1
FileDelete(@tempDir & "\BTXWeb.dat")
DirRemove(@TempDir & "/sounds", 1)
sleep(100)
exit
case $delfiles = 0
sleep(100)
exit
endselect
endfunc
Func MonitorEnable()
if $enableClip = 0 then
$enableClip = 1
$cliptext = clipget()
Speaking(translate($idioma, "Clipboard monitoring enabled"))
GUICtrlSetState($idMonitor, $GUI_CHECKED)
Else
$enableClip = 0
Speaking(translate($idioma, "Clipboard monitoring disabled"))
GUICtrlSetState($idMonitor, $GUI_UNCHECKED)
EndIf
EndFunc
Func readclip()
$cliptext = ClipGet()
if @error = "1" then
speaking(translate($idioma, "No text in the clipboard"))
Else
if StringLen($cliptext) >3000 then
Speaking(translate($idioma, "The clipboard text is more than three thousand characters."))
Else
speaking(translate($idioma, "Contents:") &" " &$cliptext)
EndIf
EndIf
EndFunc
func Readasdialogue()
GuiSetState(@SW_Hide, $Gui_main)
$Gui2= GuiCreate("Clipboard contents:")
GuiSetState(@SW_SHOW)
sleep(200)
$cliptext = ClipGet()
if $cliptext = "" then
TTsDialog(translate($idioma, "No text in the clipboard"))
Else
TTsDialog($cliptext)
EndIf
GuiDelete($Gui2)
GuiSetState(@SW_SHOW, $Gui_main)
EndFunc
Func ReadAsDocument()
$gui3 = GuiCreate(translate($idioma, "Reading clipboard history"))
GuiSetState(@SW_SHOW)
sleep(200)
createTtsOutput("config\cliphistory.btx", translate($idioma, "History"))
GuiDelete($gui3)
EndFunc
func SendData()
if $enablehst = "yes" then global $inHistory = FileOpen(@scriptdir & "\config\Cliphistory.btx", 1)
GuiSetState(@SW_Hide, $Gui_main)
global $datatosend = ""
global $filesent = ""
global $selectedfile=0
global $Gui4= GuiCreate("Send data to clipboard")
$texttosend = GUICtrlCreateLabel(translate($idioma, "Write the text to send"), 20, 50, 100, 20)
global $sendinput = GUICtrlCreateInput("", 20, 100, 100, 20)
global $BTN_file = GUICtrlCreateButton(translate($idioma, "Or if not, select a file"), 100, 50, 100, 20)
GUICtrlSetOnEvent(-1, "Selectfile")
global $BTN_Ok = GUICtrlCreateButton(translate($idioma, "OK"), 140, 50, 100, 20)
GUICtrlSetOnEvent(-1, "OKdata")
global $BTN_Cancel = GUICtrlCreateButton(translate($idioma, "Cancel"), 175, 50, 100, 20)
GUICtrlSetOnEvent(-1, "CloseSendData")
GuiSetState(@SW_SHOW)
EndFunc
func CloseSendData()
if $enablehst = "yes" then FileClose($inHistory)
GuiDelete($Gui4)
GuiSetState(@SW_SHOW, $Gui_main)
EndFunc
Func Selectfile()
$filesent = FileOpenDialog(translate($idioma, "Select a file"), "", translate($idioma, "All Files (*.*)"))
If @error Then
$selectedfile=0
MsgBox(16, translate($idioma, "error"), translate($idioma, "you did not select any file."))
else
Beep(1000, 50)
Speaking(translate($idioma, "File Selected:") &" " &$filesent)
$selectedfile=1
EndIF
EndFunc
func OKdata()
If $selectedfile = 1 then
ClipPut($filesent)
if $enablehst = "yes" then FileWriteLine($inHistory, $filesent)
CloseSendData()
else
Global $datatosend = GUICtrlRead($sendinput)
if $datatosend ="" then
msgbox(16, translate($idioma, "Error"), translate($idioma, "There is no text on the clipboard. You must enter something to send."))
else
ClipPut($datatosend)
if $enablehst = "yes" then FileWriteLine($inHistory, $datatosend)
CloseSendData()
EndIF
EndIF
EndFunc
Func MonitorEnable2()
if $idioma = "es" then
if $enableVoice = 0 then
If FileExists(@tempDir &"\BTX-voices") then
$enableVoice = 1
$cliptext = clipget()
if $enableClip = 1 then
Speaking(translate($idioma, "Use other voice enabled"))
HablarEnLetras("Es_default", translate($idioma, "Use other voice enabled"))
GUICtrlSetState($idMonitor2, $GUI_CHECKED)
else
Speaking(translate($idioma, "To activate this option you need to have the monitoring turned on."))
MSgBox(16, translate($idioma, "Error"), translate($idioma, "To activate this option you need to have the monitoring turned on."))
GUICtrlSetState($idMonitor2, $GUI_UNCHECKED)
$enableVoice = 0
EndIF
else
$dvoices1 = MsgBox(4, translate($idioma, "Notice"), translate($idioma, "You don't have independent voices downloaded. Would you like to do it?"))
if $dvoices1 = 6 then
Downloadvoices()
Else
GUICtrlSetState($idMonitor2, $GUI_UNCHECKED)
Speaking(translate($idioma, "To activate this function you need to have at least one voice"))
MsgBox(16, translate($idioma, "Error"), translate($idioma, "To activate this function you need to have at least one voice"))
EndIf
EndIf
Else
$enableVoice = 0
Speaking(translate($idioma, "Use other voice disabled"))
GUICtrlSetState($idMonitor2, $GUI_UNCHECKED)
EndIf
else
MsgBox(16, translate($idioma, "Error"), translate($idioma, "This feature is not available in this language."))
EndIF
EndFunc
func readdocumentmanual()
global $gui5 = GuiCreate(translate($idioma, "Document reader"))
GuiSetState(@SW_SHOW)
$filename = FileOpenDialog(translate($idioma, "Select the document to open"), "", translate($idioma, "text files (*.txt)"))
If @error Then
MsgBox(16, translate($idioma, "error"), translate($idioma, "you did not select any file."))
GuiDelete($gui5)
EndIF
sleep(100)
beep(700, 100)
beep(700, 100)
createTtsOutput($filename, translate($idioma, "document opened"))
Beep(1400, 200)
speaking(translate($idioma, "The document has been closed"))
GuiDelete($gui5)
EndFunc
func readinaudio()
$filename2 = FileOpenDialog(translate($idioma, "Select the document to open"), "", translate($idioma, "text files (*.txt)"))
If @error Then
MsgBox(16, translate($idioma, "error"), translate($idioma, "you did not select any file."))
EndIF
global $abrir = FileOpen($filename2, $FO_READ)
If $abrir = -1 Then MsgBox($MB_SYSTEMMODAL, translate($idioma, "error"), translate($idioma, "An error occurred when reading the file."))
Global $docdata = FileRead($abrir)
global $gui6 = GuiCreate(translate($idioma, "Document reader"))
$control0 = GUICtrlCreateLabel(translate($idioma, "Source"), 2, 2, 50, 20, $WS_TABSTOP)
$control1 = GUICtrlCreateEdit($docdata, 5, 5, 400, 200, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
global $control2 = GUICtrlCreateLabel(translate($idioma, "&Rate"), 20, 40, 100, 20)
global $control3 = GUICtrlCreateCombo("", 80, 40, 100, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GuiCtrlSetOnEvent(-1, "voiseset")
GUICtrlSetData($control3, "-9|-8|-7|-6|-5|-4|-3|-2|-1|0|1|2|3|4|5|6|7|8|9")
global $control4 = GUICtrlCreateLabel("&Volume", 30, 110, 100, 20)
global $control5 = GuiCtrlCreateSlider(80, 110, 100, 20, Bitor($GUI_SS_DEFAULT_SLIDER, $WS_TABSTOP))
GUICtrlSetLimit(-1, 100, 0)
GuiCtrlSetOnEvent(-1, "voiseset")
GUICtrlSetData($control5, 50)
global $control6 = GUICtrlCreateButton(translate($idioma, "&Speak"), 80, 175, 100, 20)
GuiCtrlSetOnEvent(-1, "readHanddler")
global $control7 = GUICtrlCreateButton(translate($idioma, "Save as &audio"), 80, 210, 100, 20)
GuiCtrlSetOnEvent(-1, "readHanddler")
global $control8 = GUICtrlCreateButton(translate($idioma, "S&top"), 80, 265, 100, 20)
GuiCtrlSetOnEvent(-1, "ReadAudioDelete")
global $control9 = GUICtrlCreateButton(translate($idioma, "&Close"), 130, 40, 120, 20)
GuiCtrlSetOnEvent(-1, "ReadAudioDelete")
Local $sComboRead = ""
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "ReadAudioDelete")
EndFunc
func ReadAudioDelete()
select
Case @GUI_CtrlId = $control8
speak(" ", 3)
speaking(translate($idioma, "reading has stopped"))
Case @GUI_CtrlId = $control9
speak(" ", 3)
FileClose($abrir)
GUIDelete($gui6)
EndSelect
EndFunc
func voiseset()
select
Case @GUI_CtrlId = $control3
global $sComboRead = GUICtrlRead($control3)
$scrollsound.play
spRate($sComboRead)
speak(translate($idioma, "This is a speech speed test"), 3)
Case @GUI_CtrlId = $control5
global $sapivol = GUICtrlRead($control5)
$scrollsound.play
spVolume($sapivol)
speak(translate($idioma, "Volume") &" " &$sapivol, 3)
EndSelect
EndFunc
func readHanddler()
select
Case @GUI_CtrlId = $control7
Global $txtout = $docdata
$voice = _Utter_Voice_StartEngine()
_Utter_Voice_Setvolume($voice, $sapivol)
_Utter_Voice_SetRate($voice, $sComboRead)
$saveaudio = FileSaveDialog(translate($idioma, "Save audio as..."), "", translate($idioma, "MP3 audio (*.MP3)|WAV audio (*.WAV)"), $FD_FILEMUSTEXIST)
if $saveaudio = "" then
MSGBox(16, translate($idioma, "Error"), translate($idioma, "it is important that you choose a destination file before proceeding."))
else
beep(900, 50)
speaking(translate($idioma, "converting..."))
if StringInStr($saveaudio, ".mp3") then
If not FileExists(@scriptDir &"\engines\lame.exe") then
$msglame = MsgBox(4, translate($idioma, "Warning"), translate($idioma, "To export audio to mp3 you need to have the lame encoder library. Would you like to download it now?"))
If $msglame = 6 then
DownloadLame()
Else
MsgBox(48, translate($idioma, "Agree"), translate($idioma, "At the moment you can save in wav format and download lame whenever you want."))
EndIf ;$msglame
else
_Utter_Voice_Transcribe($voice, $saveaudio, $txtout, 0, @scriptDir &"\engines\lame.exe")
EndIf ;FileExists("engines\lame.exe")
EndIf
beep(1800, 100)
sleep(500)
MsgBox(48, translate($idioma, "Information"), translate($idioma, "The audio file has been converted successfully!"))
_Utter_Voice_Shutdown($voice)
EndIf
Case @GUI_CtrlId = $control6
speak($docdata, 3)
EndSelect
EndFunc
func readinvoice()
$filetoread2 = FileOpenDialog(translate($idioma, "Select the document to open"), "", translate($idioma, "text files (*.txt)"))
If @error Then
MsgBox(16, translate($idioma, "error"), translate($idioma, "you did not select any file."))
EndIF
global $abrir = FileOpen($filetoread2, $FO_READ)
If $abrir = -1 Then MsgBox(16, translate($idioma, "error"), translate($idioma, "An error occurred when reading the file."))
Global $leeme = FileRead($abrir)
select
case stringLen($leeme) = ""
MsgBox(16, translate($idioma, "Error"), translate($idioma, "You have not selected a file or it is empty."))
case stringLen($leeme) > 2000
MsgBox(16, translate($idioma, "Error"), translate($idioma, "In this version only documents of less than 2000 characters are allowed."))
case else
if $idioma = "es" then
If FileExists(@tempDir &"\BTX-voices") then
HablarEnLetras("Es_default", $leeme)
else
$dvoices2 = MsgBox(4, translate($idioma, "Notice"), translate($idioma, "You don't have independent voices downloaded. Would you like to do it?"))
if $dvoices2 = 6 then
Downloadvoices()
Else
speaking(translate($idioma, "To activate this function you need to have at least one voice"))
MsgBox(16, translate($idioma, "Error"), translate($idioma, "To activate this function you need to have at least one voice"))
EndIf
EndIf
else
MsgBox(16, translate($idioma, "Error"), translate($idioma, "This feature is not available in this language."))
EndIF
EndSelect
EndFunc
Func DownloadLame()
$iPlaces = 2
$lameurl = "https://www.dropbox.com/s/14utk87bmp7dqga/lame.exe?dl=1"
$dllame = InetGet($lameurl, @ScriptDir &"\engines\lame.exe", 1, 1)
$exeSize = InetGetSize($lameurl)
While Not InetGetInfo($dllame, 2)
Sleep(100)
$exeSize2 = InetGetInfo($dllame, 0)
$Percent = Int($exeSize2 / $exeSize * 100)
$oldpercent = $Percent
$iSize = $exeSize - $exeSize2
if $percent <> $oldPercent then
CreateAudioProgress($Percent)
speaking($Percent &"% " &_GetDisplaySize($iSize, $iPlaces = 2) & " " &translate($idioma, "remaining") &$Percent & " " &translate($idioma, "percent completed"))
EndIf
WEnd
sleep(1000)
MSgBox(48, translate($idioma, "Information"), translate($idioma, "The lame encoder has been downloaded successfully"))
EndFunc
Func report()
ShellExecute("https://docs.google.com/forms/d/e/1FAIpQLSdDW6LqMKGHjUdKmHkAZdAlgSDilHaWQG9VZjwLz0CJSXKqHA/viewform?usp=sf_link")
If @error then MsgBox(16, "Error", "Cannot run browser. It is likely that you have to add an association.")
EndFunc
func ReadChanges2()
global $openned
$doc = "documentation\" &$idioma &"\changes.txt"
global $DocOpen = FileOpen($doc, $FO_READ)
speaking(translate($idioma, "Opening..."))
If $DocOpen = "-1" Then MsgBox(16, translate($idioma, "error"), translate($idioma, "An error occurred when reading the file."))
$openned = FileRead($DocOpen)
global $mwindow = GUICreate(translate($idioma, "Changes"))
$idMyedit = GUICtrlCreateEdit($openned, 5, 5, 390, 360, BitOR($WS_VSCROLL, $WS_HSCROLL, $ES_READONLY))
$idExitDoc = GUICtrlCreateButton(translate($idioma, "Close"), 100, 370, 150, 30)
GuiCtrlSetOnEvent(-1, "delete2")
GUISetOnEvent($GUI_EVENT_CLOSE, "delete2")
GUISetState(@SW_SHOW)
EndFunc
func delete2()
FileClose($DocOpen)
GUIDelete($mwindow)
EndFunc
func newIssue()
ShellExecute("https://github.com/rmcpantoja/blind-text/issues/new")
EndFunc
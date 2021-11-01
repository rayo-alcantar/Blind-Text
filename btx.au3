#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compile_Both=N
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Description=Blind Text
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_ProductName=Blind Text
#AutoIt3Wrapper_Res_ProductVersion=0.1.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2021 MT Programs, All rights reserved
;#AutoIt3Wrapper_Res_Language=12298
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -v1 -v2 -v3
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
;#AutoIt3Wrapper_Run_Tidy=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Btx
;By Mateo Cedillo
;This little program is a suite of utilities with various tools and functions.
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(UPX, False)
;#pragma compile(Compression, 2)
;#pragma compile(inputboxres, false)
#pragma compile(FileDescription, Blind Text)
#pragma compile(ProductName, Blind Text)
#pragma compile(ProductVersion, 0.1.0.0)
#pragma compile(Fileversion, 0.1.0.0)
#pragma compile(InternalName, "mateocedillo.BTX")
#pragma compile(LegalCopyright, © 2018-2021 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
$idioma = iniRead ("config\config.st", "General settings", "language", "")
;Include
#include "include\audio.au3"
#include <AutoItConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#Include <fileConstants.au3>
#include <guiConstantsEx.au3>
#include <InetConstants.au3>
#include <include\kbc.au3>
#include <include\menu_nvda.au3>
#include <misc.au3>
#include <include\NVDAControllerClient.au3>
#include "include\progress.au3"
#include <include\reader.au3>
#include <include\sapi.au3>
#include "include\share.au3"
#include "include\translator.au3"
#include "updater.au3"
;#include <WindowsConstants.au3>
Opt("GUIOnEventMode",1)
$l1 = GUICreate(translate($idioma, "Loading..."))
GUISetState(@SW_SHOW)
global $programname="Blind text"
global $program_ver = "0.1"
global $ifitisupdate = IniRead("Config\config.st", "General settings", "Check updates", "")
If $ifitisupdate = "" then
IniWrite("Config\config.st", "General settings", "Check updates", "Yes")
$ifitisupdate = "yes"
EndIF
global $soundclose = $device.opensound ("sounds/close.ogg", true)
global $SCHECKBOX = $device.opensound ("sounds/CHECKBOX.ogg", true)
global $SCHECKBOX2 = $device.opensound ("sounds/CHECKBOX_unchecked.ogg", true)
global $errorsound = $device.opensound ("sounds/error.ogg", true)
global $open = $device.opensound ("sounds/open.ogg", true)
global $radiosound = $device.opensound ("sounds/radio.ogg", true)
global $enableClip = 0
global $enableClipOther = 0
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
;exitpersonaliced()
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
GUISetState(@SW_SHOW)
$langcount = StringSplit($obteniendo, "|")
global $Choose = GUICtrlCreateCombo("", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GuiCtrlSetOnEvent(-1, "seleccionar")
GUICtrlSetData($Choose, $obteniendo)
global $idBtn_OK = GUICtrlCreateButton("OK", 155, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "save")
global $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
GuiCtrlSetOnEvent(-1, "exitpersonaliced")
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
global $idMonitor = GUICtrlCreateMenuItem(translate($idioma, "Monitor clipboard"), $idmen1)
GUICtrlSetOnEvent(-1, "monitorEnable")
Global $idMonitor2 = GUICtrlCreateMenuItem(translate($idioma, "Monitor clipboard with a independent voice"), $idmen1)
GUICtrlSetOnEvent(-1, "monitorEnable2")
Global $idHTS = GUICtrlCreateMenuItem(translate($idioma, "History"), $idmen1)
GUICtrlSetOnEvent(-1, "cphistory")
Local $idmen2 = GUICtrlCreateMenu(translate($idioma, "Writting and reading"))
Local $idmen21 = GUICtrlCreateMenu(translate($idioma, "Read mode"), $idmen2)
Global $idreadmanual = GUICtrlCreateMenuItem(translate($idioma, "Read in document mode"), $idmen21)
GUICtrlSetOnEvent(-1, "readdocumentmanual")
Global $idreadAudio = GUICtrlCreateMenuItem(translate($idioma, "Read in audio mode"), $idmen21)
GUICtrlSetOnEvent(-1, "readinaudio")
Global $idreadOther = GUICtrlCreateMenuItem(translate($idioma, "Read with an independent voice"), $idmen21)
GUICtrlSetOnEvent(-1, "readinvoice")
Local $idmen22 = GUICtrlCreateMenu(translate($idioma, "Write"), $idmen2)
Global $idWritenew = GUICtrlCreateMenuItem(translate($idioma, "Write a new file..."), $idmen22)
GUICtrlSetOnEvent(-1, "Writefile")
Global $idEdit = GUICtrlCreateMenuItem(translate($idioma, "edit file..."), $idmen22)
GUICtrlSetOnEvent(-1, "Editfile")
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
if stringLen($cliptext) > 5000 then
speaking(Translate($idioma, "The clipboard text is more than five thousand characters."))
else
speaking($cliptext)
EndIf
EndIf
sleep(10)
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
EndFunc
Func Website()
ShellExecute("http://mateocedillo.260mb.net/")
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
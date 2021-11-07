;Options:
Func options()
global $ifsavesettings = IniRead("config\config.st", "General settings", "Save settings", "")
global $ifsavelogs = IniRead("config\config.st", "General settings", "Save logs", "")
global $ifcheckupds = IniRead("config\config.st", "General settings", "Check updates", "")
global $ifEnablecphst = IniRead("config\config.st", "Clipboard settings", "Enable clipboard history", "")
global $guioptions = GuiCreate(translate($idioma, "Options"))
global $idSavesettings = GUICtrlCreateCheckbox(translate($idioma, "Save options (recommended)"), 50, 100 +(0*25), 350, 25)
GUICtrlSetOnEvent(-1, "guardaropciones")
if $ifsavesettings = "yes" then GUICtrlSetState($idSavesettings, $GUI_CHECKED)
global $idSavelogs = GUICtrlCreateCheckbox(translate($idioma, "Save logs"), 50, 100 +(1*25), 350, 25)
GUICtrlSetOnEvent(-1, "guardarlogs")
if $ifsavelogs = "yes" then GUICtrlSetState($idSavelogs, $GUI_CHECKED)
global $idCheckUpds = GUICtrlCreateCheckbox(translate($idioma, "Check for updates (recommended)"), 50, 100 +(2*25), 350, 25)
GUICtrlSetOnEvent(-1, "buscaractualizaciones")
if $ifcheckupds = "yes" then GUICtrlSetState($idcheckupds, $GUI_CHECKED)
global $idEnablecphst = GUICtrlCreateCheckbox(translate($idioma, "Enable clipboard history"), 50, 100 +(3*25), 350, 25)
GUICtrlSetOnEvent(-1, "guardarhistorial")
if $ifEnablecphst = "yes" then GUICtrlSetState($idEnablecphst, $GUI_CHECKED)
global $voice_Label = GUICtrlCreateLabel(translate($idioma, "Select text-to-speech output"), 50, 110 +(4*25), 200, 25)
global $idChangevoice1 = GUICtrlCreateCombo("Sapi", 230, 110 +(4*25)-5, 100, 30, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData($idChangevoice1, "NVDA|JAWS")
GUICtrlSetOnEvent(-1, "Cambiarvoz")
$idDeletehst = GUICtrlCreateButton(translate($idioma, "Delete clipboard history"), 120, 240, 50, 30)
GUICtrlSetOnEvent(-1, "deletehst")
$idDeleteconfig = GUICtrlCreateButton(translate($idioma, "clear settings"), 160, 240, 50, 30)
GUICtrlSetOnEvent(-1, "clear")
$idBTN_Close = GUICtrlCreateButton(translate($idioma, "&aply"), 230, 240, 50, 30)
GUICtrlSetOnEvent(-1, "eliminar")
GUISetState(@SW_SHOW)
Local $sComboRead = ""
GUISetOnEvent($GUI_EVENT_CLOSE, "eliminar")
EndFunc
func guardarlogs()
If _IsChecked_audio($idSavelogs) Then
IniWrite("config\config.st", "General settings", "Save logs", "Yes")
Else
$sCHECKBOX2.play
IniWrite("config\config.st", "General settings", "Save logs", "No")
EndIf
EndFunc
func guardaropciones()
If _IsChecked_audio($idSavesettings) Then
IniWrite("config\config.st", "General settings", "Save settings", "Yes")
Else
$sCHECKBOX2.play
IniWrite("config\config.st", "General settings", "Save settings", "No")
EndIf
EndFunc
func buscaractualizaciones()
If _IsChecked_audio($idCheckUpds) Then
IniWrite("config\config.st", "General settings", "Check updates", "Yes")
Else
$updquest = MsgBox(4, translate($idioma, "question"), translate($idioma, "By uncheck this option you will not receive updates or messages of the day. We recommend that you keep up to date with the latest version soon. Do you want to continue?"))
if $updquest = "6" then
$sCHECKBOX2.play
IniWrite("config\config.st", "General settings", "Check updates", "No")
else
GUICtrlSetState($idcheckupds, $GUI_CHECKED)
EndIf
EndIf
EndFunc
func cambiarvoz()
$sComboRead = GUICtrlRead($idchangevoice1)
IniWrite("Config\config.st", "Accessibility", "Speak Whit", $sComboRead)
$scrollsound.play
speaking(translate($idioma, "This is a speech synthesis test"))
EndFunc
func eliminar()
guiDelete($guioptions)
EndFunc
Func _IsChecked_audio($idControlID)
$sCHECKBOX.play
Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc
func clear()
$confirmarborrado = MsgBox(4, translate($idioma, "Clear settings"), translate($idioma, "Are you sure?"))
select
case $confirmarborrado = 6
$ifisdeleting = FileDelete(@ScriptDir & "\config\config.st")
If $ifisdeleting = 0 then
MSgBox(16, "Error", "Cannot delete configs file.")
Else
MsgBox(48, translate($idioma, "Information"), translate($idioma, "Please restart BlindText for the changes to take effect."))
Exitpersonaliced()
EndIf
EndSelect
EndFunc
func deletehst()
$confirm = MsgBox(4, translate($idioma, "Delete history"), translate($idioma, "Are you sure?"))
select
case $confirm = 6
$fileDelete = FileDelete(@ScriptDir & "\config\clipistory.btx")
if $fileDelete = 1 then
MsgBox(48, translate($idioma, "Information"), translate($idioma, "Clipboard history deleted."))
Else
MsgBox(16, "Error", "The clipboard history has already been deleted before or is not activated.")
EndIF
EndSelect
EndFunc
Func Guardarhistorial()
If _IsChecked_audio($idEnablecphst) Then
IniWrite("config\config.st", "Clipboard settings", "Enable clipboard history", "Yes")
Else
$sCHECKBOX2.play
IniWrite("config\config.st", "Clipboard settings", "Enable clipboard history", "No")
EndIf
EndFunc
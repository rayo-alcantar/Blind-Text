;Voice downloader
#include <guiConstantsEx.au3>
#include "reader.au3"
#include "translator.au3"
func downloadvoices()
$voicelist = InetRead("https://www.dropbox.com/s/tugjyr45vd3ez9t/voicelist.dat?dl=1")
Local $vdata = BinaryToString($voicelist)
global $guilist = guicreate(translate($idioma, "Download voices"))
$idlabellist = GUICtrlCreateLabel(translate($idioma, "List of available voices"), 25, 50, 100, 20)
Global $idlist = GUICtrlCreateList("", 120, 50, 120, 30)
GUICtrlSetLimit(-1, 200)
global $btndownload = GUICtrlCreateButton(translate($idioma, "Download"), 160, 50, 120, 30)
GuiCtrlSetOnEvent(-1, "downloadvoice")
global $btnclose = GUICtrlCreateButton(translate($idioma, "Close"), 220, 50, 120, 30)
GuiCtrlSetOnEvent(-1, "closeddialogue")
global $loTengo = StringSplit($vdata, ",")
For $coloca = 1 To $loTengo[0] step 2
GUICtrlSetData($idlist, $loTengo[$coloca])
Next
speaking("Loaded")
GUISetState(@SW_SHOW)
EndFunc
func downloadvoice()
$searchstr = GUICtrlRead($idList)
$searchleng = StringLen($searchstr)
guiDelete($guilist)
ProgressOn(translate($idioma, "Downloading..."), "Please wait...", "0%", 100, 100, 16)
$iPlaces = 2
$download1 = InetGet($loTengo[2], @tempDir &"\es_default.zip", 1, 1)
$Size = InetGetSize($loTengo[2])
While Not InetGetInfo($download1, 2)
Sleep(50)
$Size2 = InetGetInfo($download1, 0)
$Percent = Int($Size2 / $Size * 100)
$iSize = $Size - $Size2
ProgressSet($Percent, _GetDisplaySize($iSize, $iPlaces = 2) & " " &translate($idioma, "remaining") &$Percent & " " &translate($idioma, "percent completed"))
WEnd
sleep(1000)
_Zip_UnzipAll(@tempDir &"\es_default.zip", @TempDir &"\BTX-voices", 0)
ProgressOff()
MSgBox(48, translate($idioma, "Information"), translate($idioma, "The voice has been downloaded successfully!"))
EndFunc
func closeddialogue()
GuiDelete($guilist)
EndFunc

#include "include\progress.au3"
#include "include\reader.au3"
#include "include\translator.au3"
$idioma="es"
$soundList = FileReadToArray("btx.au3")
$Contarlineas = @extended
If @error Then
MsgBox(0, translate($idioma, "error"), translate($idioma, "There was an error reading sound List. Reason: ") &" " &@error)
Else
speaking(translate($idioma, "Loading document..."))
For $i = 0 To $contarlineas - 1
$progress = int($I /$contarlineas * 100)
CreateAudioProgress($progress)
sleep(10)
Next
CreateAudioProgress("100")
speaking("loaded")
EndIf
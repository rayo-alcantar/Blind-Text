#include "include\audio.au3"
#include "include\kbc.au3"
#include <Misc.au3>
#include "include\reader.au3"
$progress = $device.opensound("sounds/progress.ogg", 0)
$number = "1"
While 1
If _IsPressed($up) Then
$progress.pitchshift=0.80
$number = $number -1
$progress.play
speaking($number)
; Wait until key is released.
While _IsPressed($up)
Sleep(100)
WEnd
EndIf
If _IsPressed($shift) and _IsPressed($up) Then
$progress.pitchshift=1.40
$number = $number +1
$progress.play
speaking($number)
; Wait until key is released.
While _IsPressed($shift) and _IsPressed($up)
Sleep(10)
WEnd
$progress.pitchshift=1
$progress.play
EndIf
if _IsPressed($escape) Then
speaking("The Esc Key was pressed, therefore we will close the application.")
beep(1000, 50)
sleep(200)
ExitLoop
EndIf
Sleep(100)
WEnd
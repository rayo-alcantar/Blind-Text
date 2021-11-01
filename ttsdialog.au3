#include <misc.au3>
#include "include\kbc.au3"
#include "include\reader.au3"
$gui= Guicreate("TTS dialog")
GuiSetState(@SW_SHOW)
sleep(1000)
TtsDialog("This is a test.")
Beep(1000, 50)
Exit
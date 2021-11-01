#include <Sound.au3>
#include <file.au3>

func Voiceplay($SToPlay)
$soundToPlay = _soundOpen("speech\voices\mateo\" &$sToPlay &random(1, 3, 1) &".wav")
_soundPlay ($soundToPlay, 0)
while _soundLength ($soundToPlay, 2) - _soundPos ($soundToPlay, 2) > 30
wend
EndFunc
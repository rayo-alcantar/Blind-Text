#include "tts.au3"
dim $characters[2048]
$textstring = "equis"
Letras($textstring)
func letras($str)
;Aplicando correcciones de diccionario:
$str = StringReplace($str, "ca", "qa")
$str = StringReplace($str, "co", "qo")
$str = StringReplace($str, "cu", "qu")
$str = StringReplace($str, "ch", "$")
$str = StringReplace($str, "ge", "je")
$str = StringReplace($str, "gi", "ji")
$str = StringReplace($str, "gue", "ge")
$str = StringReplace($str, "gui", "gi")
$str = StringReplace($str, "h", "")
$str = StringReplace($str, "ll", "y")
$str = StringReplace($str, "qu", "q")
$length=StringLen($str)
$remove = -1
$remover = $length
for $iString = 1 to $length
$remove = $remove +1
$remover = $remover -1
;$characters[$iString] = StringTrimLeft(StringTrimRight($string, 17), 0)
$characters[$iString] = StringTrimLeft(StringTrimRight($str, $remover), $remove)
VoicePlay($characters[$iString])
;MsgBox(0, "Result", $characters[$iString])
Next
;msgbox(0, "Finished", "finished")
EndFunc
Func Silabas($str)
$length=StringLen($string)
$remove = "-2"
$remover = $length
for $iString = 1 to $length
$remove = $remove +2
$remover = $remover -2
;;$characters[$iString] = StringTrimLeft(StringTrimRight($string, 17), 0)
$characters[$iString] = StringTrimLeft(StringTrimRight($string, $remover), $remove)
MsgBox(0, "Result", $characters[$iString])
Next
msgbox(0, "Finished", "finished")
EndFunc
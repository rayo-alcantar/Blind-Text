dim $characters[2048]
$string = "esta es una prueba"
$length=StringLen($string)
$remove = -1
$remover = $length
for $iString = 1 to $length
$remove = $remove +2
$remover = $remover -1
;$characters[$iString] = StringTrimLeft(StringTrimRight($string, 17), 0)
$characters[$iString] = StringTrimLeft(StringTrimRight($string, $remover), $remove)
MsgBox(0, "Result", $characters[$iString])
Next
msgbox(0, "Finished", "finished")
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "method=xml";
for $x in //w[not(descendant::w) and not(descendant::supplied) and not(ancestor::supplied) and not(ancestor::corr) and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")])]
let $form := string(translate(normalize-space($x/self::*), " ", ""))
let $length := string-length($form)
let $hw := $x/@lemma
let $hwRef := $x/@lemmaRef
let $hand := $x/preceding::handShift[1]/@new
let $msLine := if ($x/preceding::lb[1]/@sameAs) then
    string($x/preceding::lb[1]/@sameAs)
else
    string($x/preceding::lb[1]/@xml:id)
let $chars :=
for $z at $i in (1 to $length)
let $char := substring($form, $i, 1)
let $charType := if (string(translate(normalize-space(lower-case($char)), " ", "")) = ("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "x", "z"))
then
    "C"
else
    if (string(translate(normalize-space(lower-case($char)), " ", "")) = ("a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"))
    then
        "V"
    else
        "?"
return
    <char
        n="{string($i)}"
        type="{$charType}">{string(translate(normalize-space($char), " ", ""))}</char>
let $wordData := <w>{$chars}</w>
let $chars_2 :=
for $c in $wordData/char
let $num := $c/@n
let $char := string($c/self::*)
let $prevV := string($c/preceding-sibling::char[@type = "V"][1])
let $nextV := string($c/following-sibling::char[@type = "V"][1])
let $cType := if ($c/ancestor::w/char/@type = "V")
then
    if ($nextV = ("e", "i", "é", "í"))
    then
        "C´"
    else 
        if ()
        then 
        else
    else
        "C`"
else
    "C"
let $type := if (string($c/@type) = "C")
then
    if ($char = "h")
    then
        "h"
    else
        $cType
else
    if (string($c/@type) = "V")
    then
        "V"
    else
        "?"
return
    <char
        n="{$num}"
        type="{$type}">{$char}</char>
let $wshape := translate(string-join($chars_2/@type), "h?", "")
return
    <w
        lemma="{$hw}"
        lemmaRef="{$hwRef}"
        hand="{$hand}"
        ref="{$msLine}"
        wshape="{$wshape}">{$chars_2}</w>
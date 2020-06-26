declare default element namespace "http://www.tei-c.org/ns/1.0";
declare namespace  c="https://example.com/cdata";
declare option saxon:output "method=xml";
<c:data>{
for $x in //w[not(descendant::w) and not(descendant::supplied) and not(ancestor::supplied) and not(@type="data") and not(ancestor::corr) and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")])]
let $form := string(translate(normalize-space($x/self::*), " ", ""))
let $length := string-length($form)
let $hw := $x/@lemma
let $hwRef := $x/@lemmaRef
let $pos := $x/@pos
let $stem := if (count(doc("hwData.xml")//entryFree[@corresp = $hwRef]//iType) = 1)
then
    doc("hwData.xml")//entryFree[@corresp = $hwRef]//iType
else
    if (count(doc("hwData.xml")//entryFree[@corresp = $hwRef]//iType) > 1)
    then
        "var"
    else
        "-"
let $gen := if (count(doc("hwData.xml")//entryFree[@corresp = $hwRef]//iType) = 1)
then
    doc("hwData.xml")//entryFree[@corresp = $hwRef]//gen
else
    if (count(doc("hwData.xml")//entryFree[@corresp = $hwRef]//gen) > 1)
    then
        "var"
    else
        "-"
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
    <c:char
        n="{string($i)}"
        type="{$charType}">{string(translate(normalize-space($char), " ", ""))}</c:char>
let $wordData := <c:w>{$chars}</c:w>
let $syllabCount := if ($wordData/c:char/@type = "V" and $wordData/c:char/@type = "C")
then
    if ($wordData/c:char[1]/@type = "V")
    then
        count($wordData/c:char[@type = "C" and following-sibling::c:char[1]/@type = "V"]) + 1
    else
        count($wordData/c:char[@type = "C" and following-sibling::c:char[1]/@type = "V"])
else
    if ($wordData/c:char/@type = "V" and not($wordData/c:char/@type = "C"))
    then
        1
    else
        0
let $cshapes := for $c in $wordData/c:char
let $cshape := if (string($c/@type) = "?")
then
    "?"
else
    if (string($c/@type) = "C")
    then
        if (string($c) = "h")
        then
            "h"
        else
            if (string($c/following-sibling::c:char[not(string(self::*) = "h")][1]/@type) = "C")
            then
                ""
            else
                "C"
    else
        if (string($c/following-sibling::c:char[1]/@type) = "V")
        then
            ""
        else
            "V"
return
    $cshape
let $wshape := translate(string-join($cshapes), "h?", "")
return
    <c:w
        lemma="{$hw}"
        lemmaRef="{$hwRef}"
        pos="{$pos}"
        hand="{$hand}"
        ref="{$msLine}"
        wshape="{$wshape}"
        scount="{$syllabCount}"
        stem="{$stem}"
        gen="{$gen}">{$wordData/c:char}</c:w>}
</c:data>
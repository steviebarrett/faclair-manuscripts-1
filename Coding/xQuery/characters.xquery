declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "method=xml";
for $x in //w[not(descendant::w) and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")])]
let $form := string(translate(normalize-space($x/self::*), " ", ""))
let $length := string-length($form)
let $hw := $x/@lemma
let $hwRef := $x/@lemmaRef
let $hand := $x/preceding::handShift/@new
let $msLine := if ($x/preceding::lb[1]/@sameAs) then
    string($x/preceding::lb[1]/@sameAs)
else
    string($x/preceding::lb[1]/@xml:id)
let $chars := for $z at $i in (1 to $length)
let $char := substring($form, $i, 1)
return
    <char
        n="{string($i)}">{string(translate(normalize-space($char), " ", ""))}</char>
return
    <w
        lemma="{$hw}"
        lemmaRef="{$hwRef}"
        hand="{$hand}"
        ref="{$msLine}"
        >{$chars}</w>
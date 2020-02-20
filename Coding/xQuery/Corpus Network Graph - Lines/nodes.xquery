declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("id,label,pos,affil,size,aboveAverage,type", "&#10;", string-join(
for $x in //w[not(descendant::w) and not(@lemmaRef = preceding::w/@lemmaRef) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $x_id := string($x/@lemmaRef)
let $x_label := string($x/@lemma)
let $pos := string($x/@pos)
let $affil := "N/A"
let $size := "N/A"
let $aboveAverage := "N/A"
return
    concat($x_id, ",", $x_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", "word", "&#10;")
), string-join(for $y in //div[not(ancestor::div) and descendant::w]
let $y_id := string($y/@corresp)
let $y_label := string(translate(//msItem[@xml:id = $y_id]/title, ",", ""))
let $hand := //msItem[@xml:id = $y_id]/descendant::author[1]/@corresp
let $pos := "N/A"
let $affil := string(//handNote[@xml:id = $hand]/affiliation)
let $size := count($y/descendant::w[not(descendant::w)])
let $average := count(//w[not(descendant::w) and not(@type = "data")]) div count(//div[not(ancestor::div)])
let $aboveAverage := if ($size >= $average) then
    "yes"
else
    "no"
return
    concat($y_id, ",", $y_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", "text", "&#10;")
    ), string-join(for $z in //lb[@xml:id]
    let $z_id := string($z/@xml:id)
    let $z_label := $z_id
    let $hand := string(preceding::handShift[1]/@new)
    let $affil := string(//handNote[@xml:id = $hand]/affiliation)
    let $pos := "N/A"
    let $size := "N/A"
    let $aboveAverage := "N/A" 
    return
    concat($z_id, ",", $z_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", "line", "&#10;")
    )
    )
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("id,label,pos,affil,size,aboveAverage,medical,bardic,fc,legal,poetry,grammatica,type", "&#10;", string-join(
for $x in //w[not(descendant::w) and not(@lemmaRef = preceding::w/@lemmaRef) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $x_id := string($x/@lemmaRef)
let $x_label := string($x/@lemma)
let $pos := string($x/@pos)
let $affil := "N/A"
let $size := "N/A"
let $aboveAverage := "N/A"
let $medical := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "medical") then
    "yes"
else
    "no"
let $bardic := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "bardic") then
    "yes"
else
    "no"
let $fc := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "finn-cycle") then
    "yes"
else
    "no"
let $legal := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "legal") then
    "yes"
else
    "no"
let $poetry := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "poetry") then
    "yes"
else
    "no"
let $gram := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $x_id]/@corresp]//term/text() = "grammatica") then
    "yes"
else
    "no"
return
    concat($x_id, ",", $x_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", $medical, ",", $bardic, ",", $fc, ",", $legal, ",", $poetry, ",", $gram, ",", "word", "&#10;")
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
let $medical := if (//msItem[@xml:id = $y_id]//term/text() = "medical") then
    "yes"
else
    "no"
let $bardic := if (//msItem[@xml:id = $y_id]//term/text() = "bardic") then
    "yes"
else
    "no"
let $fc := if (//msItem[@xml:id = $y_id]//term/text() = "finn-cycle") then
    "yes"
else
    "no"
let $legal := if (//msItem[@xml:id = $y_id]//term/text() = "legal") then
    "yes"
else
    "no"
let $poetry := if (//msItem[@xml:id = $y_id]//term/text() = "poetry") then
    "yes"
else
    "no"
let $gram := if (//msItem[@xml:id = //div[descendant::w/@lemmaRef = $y_id]/@corresp]//term/text() = "grammatica") then
    "yes"
else
    "no"
return
    concat($y_id, ",", $y_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", $medical, ",", $bardic, ",", $fc, ",", $legal, ",", $poetry, ",", $gram, ",", "text", "&#10;")))
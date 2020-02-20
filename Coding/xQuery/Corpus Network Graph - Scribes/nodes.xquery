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
), string-join(for $y in //handNotes/handNote
let $y_id := string($y/@xml:id)
let $y_label := if ($y/forename or $y/surname) then
concat($y/forename, " ", $y/surname)
else
string($y_id)
let $hand := $y_id
let $pos := "N/A"
let $affil := string($y/affiliation)
let $size := count(//w[not(descendant::w) and not(@type = "data") and preceding::handShift[1]/@new = $y_id])
let $average := count(//w[not(descendant::w) and not(@type = "data")]) div count(//handNotes/handNote)
let $aboveAverage := if ($size >= $average) then
"yes"
else
"no"
return
concat($y_id, ",", $y_label, ",", $pos, ",", $affil, ",", $size, ",", $aboveAverage, ",", "hand", "&#10;")))
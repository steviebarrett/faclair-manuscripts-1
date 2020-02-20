declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("id,label,affiliation,type", "&#10;", string-join(
for $x in //teiCorpus//handNotes/handNote[@xml:id and not(@xml:id = "Hand999")]
let $x_id := string($x/@xml:id)
let $x_name := if($x/descendant::forename or $x/descendant::surname) then concat($x/descendant::forename, " ", $x/descendant::surname) else $x_id
let $x_affil := string($x/affiliation)
return
concat($x_id, ",", normalize-space($x_name), ",", $x_affil, ",", "scribe", "&#10;")
), string-join(
for $y in //TEI[not(@xml:id = "hwData")]
let $y_id := string($y/@xml:id)
let $y_name := translate(string($y//teiHeader/fileDesc/titleStmt/title), ",", "")
let $y_affil := "N/A"
return
concat($y_id, ",", $y_name, ",", $y_affil, ",", "ms", "&#10;")))
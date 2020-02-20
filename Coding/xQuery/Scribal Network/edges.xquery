declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("source,target", "&#10;", string-join(
for $x in //teiCorpus//handNotes/handNote[not(@xml:id = "Hand999")]
let $x_id := string($x/@xml:id)
for $y in //TEI[descendant::*[@hand = $x_id] or descendant::handShift[@new = $x_id]]
let $y_id := string($y/@xml:id)
let $source := string($x_id)
let $target := string($y_id)
return
    concat($source, ",", $target, "&#10;")
))
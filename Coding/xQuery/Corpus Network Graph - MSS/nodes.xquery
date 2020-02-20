declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("id,label,pos,size,type", "&#10;", string-join(
for $x in //w[not(descendant::w) and not(@lemmaRef = preceding::w/@lemmaRef) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $x_id := string($x/@lemmaRef)
let $x_label := string($x/@lemma)
let $pos := string($x/@pos)
let $size := "N/A"
let $aboveAverage := "N/A"
return
    concat($x_id, ",", $x_label, ",", $pos, ",", $size, ",", "word", "&#10;")
), string-join(for $y in //TEI[not(@type = "hwData")]
let $y_id := string($y/@xml:id)
let $y_label := string(translate(//TEI[@xml:id = $y_id]/teiHeader/fileDesc/titleStmt/title, ",", ""))
let $pos := "N/A"
let $size := count($y/descendant::w[not(descendant::w)])
return
    concat($y_id, ",", $y_label, ",", $pos, ",", $size, ",", "ms", "&#10;")))
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("id,label,detail,type", "&#10;", string-join(
for $x in //w[not(descendant::w) and not(@lemmaRef = preceding::w/@lemmaRef) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $x_id := string($x/@lemmaRef)
let $x_label := string($x/@lemma)
let $pos := string($x/@pos)
return
concat($x_id, ",", $x_label, ",", $pos, ",", "word", "&#10;")
), string-join(for $y in //div[not(ancestor::div) and descendant::w]
let $y_id := string($y/@corresp)
let $y_label := string(translate(//msItem[@xml:id = $y_id]/title, ",", ""))
let $hand := //msItem[@xml:id = $y_id]/descendant::author[1]/@corresp
let $affil := string(//handNote[@xml:id = $hand]/affiliation)
return
concat($y_id, ",", $y_label, ",", $affil, ",", "text", "&#10;")))
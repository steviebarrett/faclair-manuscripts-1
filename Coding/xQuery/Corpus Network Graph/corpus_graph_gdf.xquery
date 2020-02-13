declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";

concat("nodedef>name VARCHAR,label VARCHAR,detail VARCHAR,type VARCHAR","&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $x_id := string($x/@lemmaRef)
let $x_label := string($x/@lemma)
let $pos := string($x/@pos)
    where $pos = "noun" or $pos = "adjective" or $pos = "verb" or $pos = "verbal_noun" or $pos = "adverb" or $pos = "participle"
return
    concat($x_id, ",", $x_label, ",", $pos, ",", "word", "&#10;")
), string-join(for $y in //div[not(ancestor::div)]
let $y_id := string($y/@corresp)
let $y_label := string(//msItem[@xml:id = $y_id]/title)
let $hand := $y/@hand
let $affil := string(//handNote[@xml:id = $hand]/affiliation)
return
    concat($y_id, ",", $y_label, ",", $affil, ",", "text", "&#10;")), string-join(
concat("edgedef>node1 VARCHAR,node2 VARCHAR,pos VARCHAR","&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $source := string($x/ancestor::div[not(ancestor::div)]/@corresp)
let $target := string($x/@lemmaRef)
let $pos := string($x/@pos)
    where $pos = "noun" or $pos = "adjective" or $pos = "verb" or $pos = "verbal_noun" or $pos = "adverb" or $pos = "participle"
return
    concat($source, ",", $target, ",", $pos, "&#10;"))
)))
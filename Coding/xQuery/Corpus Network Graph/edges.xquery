declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("source,target,pos", "&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $source := string($x/ancestor::div[not(ancestor::div)]/@corresp)
let $target := string($x/@lemmaRef)
let $pos := string($x/@pos)
return
    concat($source, ",", $target, ",", $pos, "&#10;")
))
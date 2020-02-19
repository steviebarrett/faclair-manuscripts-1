declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";
concat("source,target,pos", "&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $source := if($x/preceding::lb[1]/@sameAs) then string($x/preceding::lb[1]/@sameAs) else string($x/preceding::lb[1]/@xml:id)
let $target := string($x/@lemmaRef)
let $pos := string($x/@pos)
return
    concat($source, ",", $target, ",", $pos, "&#10;")
), string-join(for $y in //lb[@xml:id]
let $source := string($y/ancestor::div[not(ancestor::div)]/@corresp)
let $target := string($y/@xml:id)
let $pos := "N/A"
return ($source, ",", $target, ",", $pos, "&#10;")
)
)
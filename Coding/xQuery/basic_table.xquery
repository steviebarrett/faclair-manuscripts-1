declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "method=text";
for $x in //w[not(descendant::w) and not(@xml:lang) and not(@type = "data") and @lemma]
let $msRef := if ($x/preceding::lb[1]/@sameAs) then
    string($x/preceding::lb[1]/@sameAs)
else
    string($x/preceding::lb[1]/@xml:id)
let $form := normalize-space(string($x/self::*))
let $headword := string($x/@lemma)
let $id := string($x/@lemmaRef)
let $sgHeadword := string(//entryFree[@corresp = $id]/w/@lemmaDW)
let $POS := string($x/@pos)
    order by translate($headword, "*-.", "")
return
    concat($msRef, ",", $form, ",", $headword, ",", $sgHeadword, ",", $POS, "&#10;")
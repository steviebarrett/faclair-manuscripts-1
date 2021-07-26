declare default element namespace "https://dasg.ac.uk/corpus/";
declare option saxon:output "method=text";
for $x in (10 to 18)
let $wordCount := count(//w[not(@type  = "data") and not(ancestor::w) and not(@xml:lang) and preceding::handShift[1]/@new = //handNote[ancestor::teiCorpus/teiHeader and substring(string(date),0,3) = string($x)]/@xml:id])
let $mssCount := count(//TEI[descendant::handShift/@new = //handNote[ancestor::teiCorpus/teiHeader and substring(string(date),0,3) = string($x)]/@xml:id])
return concat($x, ",", $wordCount, ",", $mssCount, "&#10;")
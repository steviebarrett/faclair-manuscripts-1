declare default element namespace "https://dasg.ac.uk/corpus/";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";

concat("Form,Headword,URL,Scribe,Affiliation,Text,HW Count (Text)", "&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type="data")]
let $form := normalize-space(string($x/self::*))
let $headword := string($x/@lemma)
let $url := string($x/@lemmaRef)
let $pos := string($x/@pos)
let $scribe := string($x/preceding::handShift[1]/@new)
let $affiliation := string(//handNote[@xml:id = $scribe]/affiliation)
let $text := string($x/ancestor::div[1][not(ancestor::div)]/@corresp)
let $textHWCount := string(count(//div[@corresp = $text]/descendant::w[@lemmaRef = $url]))
return concat($form,",", $headword,",", $url,",", $scribe,",", $affiliation,",", $text,",", $textHWCount,"&#10;")))
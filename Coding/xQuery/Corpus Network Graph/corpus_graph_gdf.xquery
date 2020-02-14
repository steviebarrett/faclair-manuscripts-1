declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=text";

concat("nodedef>name VARCHAR,label VARCHAR,detail VARCHAR,type VARCHAR", "&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@lemmaRef = preceding::w/@lemmaRef) and not(@xml:lang) and not(@type = "data")]
let $hwURL := string($x/@lemmaRef)
let $x_id := if (contains($hwURL, 'dil.ie')) then
    (substring($hwURL, 19))
else
    if (contains($hwURL, 'faclair.com')) then
        (substring($hwURL, 53))
    else
        if (contains($hwURL, 'dasg.ac.uk')) then
            (substring($hwURL, 38))
        else
            if (contains($hwURL, 'www.teanglann.ie')) then
                (substring($hwURL, 33))
            else
                if (contains($hwURL, 'www.dsl.ac.uk')) then
                    (substring($hwURL, 32))
                else
                    if (contains($hwURL, 'www.logainm.ie')) then
                        (substring($hwURL, 27))
                    else
                        if (contains($hwURL, 'www.ainmean-aite.scot')) then
                            (substring($hwURL, 41))
                        else
                            if (contains($hwURL, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?lemma=')) then
                                (substring($hwURL, 76))
                            else
                                if (contains($hwURL, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?parola=')) then
                                    (substring($hwURL, 77))
                                else
                                    if (contains($hwURL, 'www.oed.com')) then
                                        (substring($hwURL, 32))
                                    else
                                        ""
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
concat("edgedef>node1 VARCHAR,node2 VARCHAR,pos VARCHAR", "&#10;", string-join(
for $x in //w[not(descendant::w) and @lemmaRef and not(@xml:lang) and not(@type = "data")]
let $source := string($x/ancestor::div[not(ancestor::div)]/@corresp)
let $hwURL := string($x/@lemmaRef)
let $target := if (contains($hwURL, 'dil.ie')) then
    (substring($hwURL, 19))
else
    if (contains($hwURL, 'faclair.com')) then
        (substring($hwURL, 53))
    else
        if (contains($hwURL, 'dasg.ac.uk')) then
            (substring($hwURL, 38))
        else
            if (contains($hwURL, 'www.teanglann.ie')) then
                (substring($hwURL, 33))
            else
                if (contains($hwURL, 'www.dsl.ac.uk')) then
                    (substring($hwURL, 32))
                else
                    if (contains($hwURL, 'www.logainm.ie')) then
                        (substring($hwURL, 27))
                    else
                        if (contains($hwURL, 'www.ainmean-aite.scot')) then
                            (substring($hwURL, 41))
                        else
                            if (contains($hwURL, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?lemma=')) then
                                (substring($hwURL, 76))
                            else
                                if (contains($hwURL, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?parola=')) then
                                    (substring($hwURL, 77))
                                else
                                    if (contains($hwURL, 'www.oed.com')) then
                                        (substring($hwURL, 32))
                                    else
                                        ""
let $pos := string($x/@pos)
    where $pos = "noun" or $pos = "adjective" or $pos = "verb" or $pos = "verbal_noun" or $pos = "adverb" or $pos = "participle"
return
    concat($source, ",", $target, ",", $pos, "&#10;"))
)))
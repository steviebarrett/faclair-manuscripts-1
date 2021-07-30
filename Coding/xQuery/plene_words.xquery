declare default element namespace "https://dasg.ac.uk/corpus/";
(: Seems to be designed for use with characters.xquery :)
declare namespace c = "https://example.com/cdata";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=html";
<html>
    <head>
        <title>Abbreviations</title>
    </head>
    <body>
        <table>
            <thead>
                <tr>
                    <th>Form</th>
                    <th>Shape</th>
                    <th>Syllables</th>
                    <th>Headword</th>
                    <th>POS</th>
                    <th>Hand</th>
                    <th>MS Ref</th>
                </tr>
                {
                    for $x in //c:w
                    let $form := string(translate(normalize-space($x), " ", ""))
                    let $shape := $x/@wshape
                    let $syllables := $x/@scount
                    let $hw := if ($x/@lemma) then
                        $x/@lemma
                    else
                        "NO_HEADWORD"
                    let $hwRef := $x/@lemmaRef
                    let $pos := $x/@pos
                    let $hand := $x/@hand
                    let $ref := $x/@ref
                    where number($syllables) > 1
                    return
                        <tr>
                            <td>{$form}</td>
                            <td>{string($shape)}</td>
                            <td>{string($syllables)}</td>
                            <td><a
                                    href="{$hwRef}"
                                    target="_blank">{string($hw)}</a></td>
                            <td>{string($pos)}</td>
                            <td>{string($hand)}</td>
                            <td>{string($ref)}</td>
                        </tr>
                }
            </thead>
            <tbody>
            </tbody>
        </table>
    </body>
</html>
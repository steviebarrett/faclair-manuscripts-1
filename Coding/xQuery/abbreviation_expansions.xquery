declare default element namespace "http://www.tei-c.org/ns/1.0";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=html";
(: This xQuery produces a table of abbreviations, how they are expanded, and the word in which they appear, 
as well as the hand responsible and the MS line reference. It is sorted by abbreviation type. :)
<html>
    <head>
        <title>Abbreviations</title>
    </head>
    <body>
        <table>
            <thead>
                <tr>
                    <th>Glyph ID</th>
                    <th>Glyph Exp.</th>
                    <th>Word Context</th>
                    <th>Word Context (HW)</th>
                    <th>Hand</th>
                    <th>MS Ref</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $x in //g[contains(@ref, "g")]
                    let $glyph_id := $x/@ref
                    let $glyph_exp := string($x/self::*)
                    let $word_context := $x/ancestor::w[1]/string(normalize-space(self::*))
                    let $word_context_hw := $x/ancestor::w[1]/@lemmaRef
                    let $hand := $x/preceding::handShift[1]/@new
                    let $ms_ref := if ($x/preceding::lb[1]/@sameAs) then
                        string($x/preceding::lb[1]/@sameAs)
                    else
                        string($x/preceding::lb[1]/@xml:id)
                    order by $glyph_id
                    return
                        <tr>
                            <td>{string($glyph_id)}</td>
                            <td>{string($glyph_exp)}</td>
                            <td>{string($word_context)}</td>
                            <td>{string($word_context_hw)}</td>
                            <td>{string($hand)}</td>
                            <td>{string($ms_ref)}</td>
                        </tr>
                }
            </tbody>
        </table>
    </body>
</html>
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
                    <th>Context Word</th>
                    <th>Context Word (HW)</th>
                    <th>Context Word (POS)</th>
                    <th>Context Word (Plene)</th>
                    <th>Hand</th>
                    <th>MS Ref</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $x in //g[contains(@ref, "g")]
                    let $glyph_id := $x/@ref
                    let $glyph_exp := string($x/self::*)
                    let $word_context_hw := $x/ancestor::w[1]/@lemma
                    let $word_context_hwRef := $x/ancestor::w[1]/@lemmaRef
                    let $word_context_pos := $x/ancestor::w[1]/@pos
                    let $hand := $x/preceding::handShift[1]/@new
                    let $ms_ref := if ($x/preceding::lb[1]/@sameAs) then
                        string($x/preceding::lb[1]/@sameAs)
                    else
                        string($x/preceding::lb[1]/@xml:id)
                    let $word_context := $x/ancestor::w[1][not(descendant::del) and not(descendant::supplied)]
                        order by substring(string($glyph_id),2)
                    return
                        <tr>
                            <td>{string($glyph_id)}</td>
                            <td>{string($glyph_exp)}</td>
                            <td>{string(translate(normalize-space($word_context), " ", ""))}</td>
                            <td><a
                                    href="{$word_context_hwRef}"
                                    target="_blank">{string($word_context_hw)}</a></td>
                            <td>{string($word_context_pos)}</td>
                            <td>{
                                    for $y in //w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g[contains(@ref, "g") and not(@ref = "g4")])]
                                    let $form := string($y/self::*)
                                        where $y/not(preceding::w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g) and string(self::*) = $form])
                                    return
                                        if ($y[not(following::w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g)])])
                                        then
                                            string(translate(normalize-space($form), " ", ""))
                                        else
                                            concat(string(translate(normalize-space($form), " ", "")), ", ")
                                }</td>
                            <td>{string($hand)}</td>
                            <td>{string($ms_ref)}</td>
                        </tr>
                }
            </tbody>
        </table>
    </body>
</html>
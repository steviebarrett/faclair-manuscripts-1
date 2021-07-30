declare default element namespace "https://dasg.ac.uk/corpus/";
declare namespace c = "https://example.com/cdata";
declare option saxon:output "omit-xml-declaration=yes";
declare option saxon:output "method=html";
(: This xQuery produces a table of abbreviations, how they are expanded, and the word in which they appear, 
as well as the hand responsible and the MS line reference. It also shows the same word written plene by the 
same scribe and a list of similarly shaped words of the same POS and in the same hand. It is sorted by abbreviation type. :)
(: NB: Revisiting this file in July 2021, it ran for a long time on the corpus without producing results and the query eventually had to be aborted. It should be used with caution. :)
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
                    <th>Cword</th>
                    <th>Cword Shape</th>
                    <th>Hand</th>
                    <th>MS Ref</th>
                    <th>Cword (HW)</th>
                    <th>Cword (POS)</th>
                    <th>Cword (Plene Examples)</th>
                    <th>Words with Cword Shape</th>
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
                    let $cword_shape := for $y in string(translate(normalize-space($word_context/self::*), " ", ""))
                    let $length := string-length($y)
                    let $chars :=
                    for $z at $i in (1 to $length)
                    let $char := substring($y, $i, 1)
                    let $charType := if (string(translate(normalize-space(lower-case($char)), " ", "")) = ("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "x", "z"))
                    then
                        "C"
                    else
                        if (string(translate(normalize-space(lower-case($char)), " ", "")) = ("a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"))
                        then
                            "V"
                        else
                            "?"
                    return
                        <char
                            n="{string($i)}"
                            type="{$charType}">{string(translate(normalize-space($char), " ", ""))}</char>
                    let $wordData := <w>{$chars}</w>
                    let $syllabCount := if ($wordData/char/@type = "V" and $wordData/char/@type = "C")
                    then
                        if ($wordData/char[1]/@type = "V")
                        then
                            count($wordData/char[@type = "C" and following-sibling::char[1]/@type = "V"]) + 1
                        else
                            count($wordData/char[@type = "C" and following-sibling::char[1]/@type = "V"])
                    else
                        if ($wordData/char/@type = "V" and not($wordData/char/@type = "C"))
                        then
                            1
                        else
                            0
                    let $cshapes := for $c in $wordData/char
                    let $cshape := if (string($c/@type) = "?")
                    then
                        "?"
                    else
                        if (string($c/@type) = "C")
                        then
                            if (string($c) = "h")
                            then
                                "h"
                            else
                                if (string($c/following-sibling::char[not(string(self::*) = "h")][1]/@type) = "C")
                                then
                                    ""
                                else
                                    "C"
                        else
                            if (string($c/following-sibling::char[1]/@type) = "V")
                            then
                                ""
                            else
                                "V"
                    return
                        $cshape
                    let $wshape := translate(string-join($cshapes), "h?", "")
                    return
                        $wshape
                        order by substring(string($glyph_id), 2)
                    return
                        <tr>
                            <td>{string($glyph_id)}</td>
                            <td>{string($glyph_exp)}</td>
                            <td>{string(translate(normalize-space($word_context), " ", ""))}</td>
                            <td>{$cword_shape}</td>
                            <td>{string($hand)}</td>
                            <td>{string($ms_ref)}</td>
                            <td><a
                                    href="{$word_context_hwRef}"
                                    target="_blank">{string($word_context_hw)}</a></td>
                            <td>{string($word_context_pos)}</td>
                            <td>{
                                    for $y in //w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")])]
                                    let $form := string($y/self::*)
                                        where $y/not(preceding::w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")]) and string(self::*) = $form])
                                    return
                                        if ($y[not(following::w[@lemmaRef = $word_context_hwRef and preceding::handShift[1]/@new = $hand and not(descendant::g[contains(@ref, "g") and not(@ref = "g4") and not(@ref = "g8") and not(@ref = "g11") and not(@ref = "g13") and not(@ref = "g67") and not(@ref = "g72") and not(@ref = "g77")])])])
                                        then
                                            string(translate(normalize-space($form), " ", ""))
                                        else
                                            concat(string(translate(normalize-space($form), " ", "")), ", ")
                                }</td>
                            <td>
                                {
                                    for $w in doc("Data/character_data/cData.xml")/c:data/c:w[@pos = $word_context_pos and @hand = $hand and @wshape = $cword_shape and @lemmaRef != $word_context_hwRef]
                                        where $w[not(preceding::c:w[@pos = $word_context_pos and @hand = $hand and @wshape = $cword_shape and @lemmaRef != $word_context_hwRef and string(normalize-space(self::*)) = string(normalize-space($w))])]
                                    return
                                        concat(string(translate(normalize-space($w), " ", "")), ", ")
                                }
                            </td>
                        </tr>
                }
            </tbody>
        </table>
    </body>
</html>
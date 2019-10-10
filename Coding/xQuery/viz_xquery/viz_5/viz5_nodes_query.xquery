declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html
    xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta
            http-equiv="Content-Type"
            content="text/html; charset=UTF-8"/>
    </head>
    <body>
        <table>
            <tr>
                <th>id</th>
                <th>label</th>
                <th>type</th>
                <th>scribe</th>
                <th>affiliation</th>
            </tr>
            {
                for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and not(ancestor::tei:name) and @lemmaRef and not(@lemmaRef = preceding::tei:w[not(ancestor::tei:name)]/@lemmaRef)]
                let $hw_id := string($x/@lemmaRef)
                let $hw_label := string($x/@lemma)
                let $lemText := string($x/ancestor::tei:div[not(ancestor::tei:div)]/@corresp)
                let $textClass := "medical"
                where $x/ancestor::tei:TEI//tei:msItem[descendant::tei:term[string(self::*) = $textClass] and @xml:id = $lemText]
                return
                    <tr><td>{$hw_id}</td><td>{$hw_label}</td><td>headword</td><td>null</td><td>null</td></tr>
            }
            {
                for $y in //tei:div[not(ancestor::tei:div) and not(@resp = preceding::tei:div[not(ancestor::tei:div)]/@corresp)]
                let $text_id := string($y/@corresp)
                let $scribe_id := string(//tei:div[not(ancestor::tei:div) and not(@corresp = preceding::tei:div[not(ancestor::tei:div)]/@corresp) and @corresp = $text_id]/@resp)
                let $text_label := concat(//tei:msItem[@xml:id = $text_id]/tei:title, " (", $text_id, ")")
                let $text_affil := string(//tei:handNote[@xml:id = $scribe_id]/tei:affiliation)
                let $textClass := "medical"
                where $y/ancestor::tei:TEI//tei:msItem[descendant::tei:term[string(self::*) = $textClass] and @xml:id = $text_id]
                return
                    <tr><td>{$text_id}</td><td>{$text_label}</td><td>text</td><td>{$scribe_id}</td><td>{$text_affil}</td></tr>
            }
        </table>
    </body>
</html>

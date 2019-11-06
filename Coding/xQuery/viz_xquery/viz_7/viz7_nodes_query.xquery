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
                <th>affiliation</th>
            </tr>
            {
                for $x in //tei:glyph
                let $g_id := string($x/@xml:id)
                let $g_label := string($x/tei:glyphName)
                return
                    <tr><td>{$g_id}</td><td>{$g_label}</td><td>glyph</td><td>null</td></tr>
            }
            {
                for $z in //tei:div[not(ancestor::tei:div) and not(@resp = preceding::tei:div[not(ancestor::tei:div)]/@corresp)]/@corresp
                let $text_id := string($z)
                let $scribe_id := string(//tei:div[not(ancestor::tei:div) and not(@corresp = preceding::tei:div[not(ancestor::tei:div)]/@corresp) and @corresp = $z]/@resp)
                let $text_label := string(//tei:msItem[@xml:id = $z]/tei:title)
                let $text_affil := string(//tei:handNote[@xml:id = $scribe_id]/tei:affiliation)
                return
                    <tr><td>{$text_id}</td><td>{$text_label}</td><td>text</td><td>{$text_affil}</td></tr>
            }
        </table>
    </body>
</html>

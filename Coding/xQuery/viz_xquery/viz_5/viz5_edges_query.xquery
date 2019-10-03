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
                <th>source</th>
                <th>target</th>
                <th>type</th>
            </tr>
            {
                for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and not(ancestor::tei:name)]
                let $lemRef := string($x/@lemmaRef)
                let $lemText := string($x/ancestor::tei:div[not(ancestor::tei:div)]/@corresp)
                let $textClass := "finn-cycle"
                where $x/ancestor::tei:TEI//tei:msItem[descendant::tei:term[string(self::*) = $textClass] and @xml:id = $lemText]
                return
                    <tr><td>{$lemText}</td><td>{$lemRef}</td><td>word</td></tr>
            }
            {
                for $z in //tei:div[not(ancestor::tei:div)]
                let $textID := string($z/@corresp)
                let $textScribe := string($z/@resp)
                let $textClass := "finn-cycle"
                where $z/ancestor::tei:TEI//tei:msItem[descendant::tei:term[string(self::*) = $textClass] and @xml:id = $textID]
                return
                    <tr><td>{$textScribe}</td><td>{$textID}</td><td>text</td></tr>
            }
        </table>
    </body>
</html>

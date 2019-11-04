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
                <th>relationship</th>
            </tr>
            {
                for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and not(ancestor::tei:name)]
                let $lemRef := string($x/@lemmaRef)
                let $lemText := string($x/ancestor::tei:div[not(ancestor::tei:div)]/@corresp)
                where count(//tei:div[not(ancestor::tei:div) and descendant::tei:w[@lemmaRef = $lemRef]]) > 1
                return
                    <tr><td>{$lemText}</td><td>{$lemRef}</td><td>directed</td><td>word</td></tr>
            }
        </table>
    </body>
</html>

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
                for $x in //tei:g[@ref]
                let $lemRef := string($x/@ref)
                let $lemText := string($x/ancestor::tei:div[not(ancestor::tei:div)]/@corresp)
                return
                    <tr><td>{$lemText}</td><td>{$lemRef}</td><td>directed</td><td>glyph</td></tr>
            }
        </table>
    </body>
</html>

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
                for $y in //tei:w[not(descendant::tei:w) and @lemmaRef and not(@xml:lang) and not(@type="data")]
                let $y_lemRef := $y/@lemmaRef
                let $y_textRef := $y/ancestor::tei:div[not(ancestor::tei:div)]/@corresp
                where //tei:div[@corresp="MS12.3"]//tei:w[@lemmaRef = $y_lemRef]
                return <tr><td>{string($y_textRef)}</td><td>{string($y_lemRef)}</td><td>word</td></tr>
            }
        </table>
    </body>
</html>

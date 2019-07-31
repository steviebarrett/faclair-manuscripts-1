declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Abbreviations</title>
<body>
<table>
<tr><th>Div</th><th>Abbreviation</th></tr>
{
for $x in //tei:g
let $ref := $x/@ref
let $name := string(//tei:glyph[@xml:id = $ref]/tei:glyphName)
let $div_ref := string($x/ancestor::tei:div[1]/@corresp)
order by $name
return <tr><td>{$div_ref}</td><td>{$name}</td></tr>
}
</table>
</body>
</head>
</html>
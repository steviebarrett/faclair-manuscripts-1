declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
<body>
<table>
<tr>
<th>source</th>
<th>target</th>
</tr>
{
for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and not(ancestor::tei:name)]
let $lemRef := string($x/@lemmaRef)
let $lemScribe := string($x/ancestor::tei:div[1]/@resp)
return <tr><td>{$lemScribe}</td><td>{$lemRef}</td></tr>
}
</table>
</body>
</html>

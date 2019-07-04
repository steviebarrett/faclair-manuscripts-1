declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
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
for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and not(ancestor::tei:name) and @lemmaRef and not(@lemmaRef = preceding::tei:w[not(ancestor::tei:name)]/@lemmaRef)]
let $hw_id := string($x/@lemmaRef)
let $hw_label := string($x/@lemma)
return <tr><td>{$hw_id}</td><td>{$hw_label}</td><td>headword</td><td>null</td></tr>
}
{
for $z in //tei:div[not(descendant::tei:div) and not(@resp = preceding::tei:div[not(descendant::tei:div)]/@resp)]/@resp
let $scribe_id := string($z)
let $scribe_label := concat(//tei:handNote[@xml:id = $z]/tei:forename, " ", //tei:handNote[@xml:id = $z]/tei:surname, " ", "[", $scribe_id, "]")
let $scribe_affil := string(//tei:handNote[@xml:id = $z]/tei:affiliation)
return <tr><td>{$scribe_id}</td><td>{$scribe_label}</td><td>scribe</td><td>{$scribe_affil}</td></tr>
}
</table>
</body>
</html>

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";
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
<th>Headword</th>
<th>Form</th>
<th>Context</th>
</tr>
{
for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and @lemmaRef]
let $hw := string($x/@lemma)
let $hwRef := $x/@lemmaRef
let $form := $x/string(self::*)
let $lineRef := $x/preceding::tei:lb[1]/@xml:id
let $line := //*[preceding::tei:lb[1]/@xml:id = $lineRef]
return
<tr><td><a
href="{$hwRef}"
target="_blank">{$hw}</a></td><td>{$form}</td><td>{
for $y in $line
where $y/ancestor::tei:sic or not($y/ancestor::tei:choice)
return if(name($y) = "w" and not($y/descendant::tei:w)) then string($y/self::*) else (if(name($y) = "space") then "SPACE" else "")
}
</td></tr>
}
</table>
</body>
</html>
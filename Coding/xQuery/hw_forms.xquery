declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title>Instances of "ocus" etc</title>
</head>
<body>
<table>
<tr><th>Form</th><th>Location</th></tr>
{
for $x in //tei:w[@lemmaRef = "http://www.dil.ie/33484" and not(@type = "data")]
let $form := normalize-space(string($x))
let $location := if($x/preceding::tei:lb[1]/@sameAs) then string($x/preceding::tei:lb[1]/@sameAs) else string($x/preceding::tei:lb[1]/@xml:id)
return <tr><td>{$form}</td><td>{$location}</td></tr>
}
</table>
</body>
</html>
declare namespace tei = "https://dasg.ac.uk/corpus/";
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
(:USER: update title based on usage. :)
<title>Instances of "ocus" etc</title>
</head>
<body>
<table>
<tr><th>Form</th><th>Location</th></tr>
{
(:USER: specify sought for word with its URL in @LemmaRef. :)
for $x in //tei:w[@lemmaRef = "http://www.dil.ie/33484" and not(@type = "data")]
let $form := normalize-space(string($x))
let $location := if($x/preceding::tei:lb[1]/@sameAs) then string($x/preceding::tei:lb[1]/@sameAs) else string($x/preceding::tei:lb[1]/@xml:id)
return <tr><td>{$form}</td><td>{$location}</td></tr>
}
</table>
</body>
</html>
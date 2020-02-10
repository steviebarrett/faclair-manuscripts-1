<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>DASG-MSS tool</title>
  </head>
<?php
$t = $_GET["t"];
?>
  <body>
<?php
$ms = new SimpleXMLElement("../../Transcribing/Transcriptions/transcription" . $t . ".xml", 0, true);
$xsl = new DOMDocument;
$xsl->load('../Stylesheets/meta.xsl');
$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);
echo $proc->transformToXML($ms);
?>

  </body>
</html>

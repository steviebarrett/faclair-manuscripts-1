<!doctype html>
<html lang="en" style="height: 100%">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <title>DASG-MSS dictionary</title>
  </head>
  <body style="height: 100%; padding-top: 80px;">
    <div class="container-fluid" style="height: 100%;">
      <nav class="navbar navbar-dark bg-primary fixed-top navbar-expand-lg">
        <a class="navbar-brand" href="index.php">DASG-MSS</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
          <div class="navbar-nav">
             <a class="nav-item nav-link" id="numbersToggle" href="#" data-toggle="tooltip" title="show/hide line/page numbers and handshifts">toggle</a>
          </div>
        </div>
      </nav>
<?php
$ms = new SimpleXMLElement("Transcribing/hwData.xml", 0, true);
$ms->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
$xsl = new DOMDocument;
$xsl->load('Coding/Stylesheets/dictionary.xsl');
$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);
echo $proc->transformToXML($ms);
?>
    </div>
  </body>
</html>
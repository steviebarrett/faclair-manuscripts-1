<!doctype html>
<!-- 
This script (called by ../../index.php) takes two obligatory input parameters:
  t: the MS number, e.g. 1, 2, 3, ...
  diplo: yes, no

It displays the MS with three columns:
1. a headword index
2. a MSS view (diplomatic or semi-diplomatic)
3. an information panel

There are a couple of extra, default hidden panels as well:
1. a form for adding comments
2. a div for displaying 'hand' information
Dependent files are:
1. ../Stylesheets/common.css (styles relevant to page as a whole, or to both MS views) 
2. ../Stylesheets/diplomatic.css | ../Stylesheets/semiDiplomatic.css (MS view specific styles)
3. common.js (event handlers relevant to page as a whole, or to both MS views)
4. diplomatic.js | semiDiplomatic.js (MS view specific event handlers)
5. comments.js (event handlers relevant to the comment system only)
6. ../Stylesheets/diplomatic.xsl | ../Stylesheets/semiDiplomatic.xsl (MS view specific XSLT scripts)
-->
<html lang="en" style="height: 100%">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="../Stylesheets/common.css"/>
    <link rel="stylesheet" href="../Stylesheets/comments.css"/>
<?php
$diplo = $_GET["diplo"];
$t = $_GET["t"];
if ($diplo=='yes') echo '<link rel="stylesheet" href="../Stylesheets/diplomatic.css"/>';
else echo '<link rel="stylesheet" href="../Stylesheets/semiDiplomatic.css"/>';
?>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    <script src="common.js"></script>
<?php
if ($diplo=='yes') echo '<script src="diplomatic.js"></script>';
else echo '<script src="semiDiplomatic.js"></script>';
?>
    <script src="comments.js"></script>
    <title>DASG-MSS tool</title>
  </head>
  <body style="height: 100%;">
    <div class="container-fluid" style="height: 100%;">
      <!-- comment form markup (usually hidden) -->
      <div class="modal fade" id="commentForm" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">Comment</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="close">
                <span aria-hidden="true"></span>
              </button>
            </div>
            <div class="modal-body">
              <select id="commentUser">
                <option value="">- Select a user -</option>
                <option value="et">Eystein</option>
                <option value="mm">Martina</option>
                <option value="wg">Willie</option>
              </select>
              <textarea rows="7" cols="40" id="commentContent"></textarea><br/><br/>
            </div>
            <input type="hidden" id="docid" value="<?php echo $t; ?>"/> <!-- MM: this is nice! didn't know you could do that -->
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary cancelComment" data-dismiss="modal">close</button>
              <button type="button" class="btn btn-primary saveComment">save</button>
            </div>
          </div>
        </div>
      </div>
      <!-- main body of display, with three columns -->
      <div class="row" style="height: 100%;">
        <div class="col-2" style="overflow: auto; height: 100%;"> <!-- the headword index -->
          <div class="list-group list-group-flush">
<?php
$ms = new SimpleXMLElement("../../Transcribing/Transcriptions/transcription" . $t . ".xml", 0, true);
$ms->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
$lemmas = [];
foreach ($ms->xpath('descendant::tei:w[@lemmaRef and not(descendant::tei:w)]') as $nextWord) {
  $pair = array($nextWord["lemma"], $nextWord['lemmaRef']);
  $lemmas[] = implode("|", $pair);
}
$counts = array_count_values($lemmas);
$lemmas = array_unique($lemmas);
usort($lemmas,'gdSort'); 
function gdSort($s, $t) {
    $s = trim($s,'*-.');
    $t = trim($t,'*-.');
    $accentedvowels = array('à','è','ì','ò','ù','À','È','Ì','Ò','Ù','ê','ŷ','ŵ','â','á','é','í','ó','ú','Á','É','Í','Ó','Ú');
    $unaccentedvowels = array('a','e','i','o','u','A','E','I','O','U','e','y','w','a','a','e','i','o','u','A','E','I','O','U');
    $str3 = str_replace($accentedvowels,$unaccentedvowels,$s);
    $str4 = str_replace($accentedvowels,$unaccentedvowels,$t);
    return strcasecmp($str3,$str4);
}
foreach ($lemmas as $nextLemma) {
  $n = $counts[$nextLemma];
  $pair = explode("|", $nextLemma);
  echo '<div class="list-group-item list-group-item-action"><span class="indexHeadword" data-uri="' . $pair[1] . '">' . $pair[0] . '</span> <span class="hwCount badge badge-light">' . $n . '</span> <a href="#" class="implode badge badge-light">-</a> <a href="#" class="explode badge badge-light">+</a></div>';
  // Note that each HW HAS class="indexHeadword" for event handling
}
?> 
          </div>  
        </div>
        <div id="midl" class="col-5" style="overflow: auto; height: 100%;"> <!-- the MSS display panel in the middle; note that id="midl" for event handling -->     
<?php
$xsl = new DOMDocument;
if ($diplo=='yes') { $xsl->load('../Stylesheets/diplomatic.xsl'); }
else { $xsl->load('../Stylesheets/semiDiplomatic.xsl'); }
$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);
echo $proc->transformToXML($ms);
?>
        </div>
        <div id="rhs" class="col-5" style="overflow: auto; height: 100%;"> <!-- the chunk info panel, on the right; id="rhs" as target for event handling -->
        </div>
      </div>
    </div>
  </body>
</html>

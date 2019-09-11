<!doctype html>
<html lang="en" style="height: 100%">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="../Stylesheets/diplomatic.css">
    
    <!-- <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script> -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/bPopup/0.11.0/jquery.bpopup.min.js"/>-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
    
    <script src="diplomatic.js"></script>
    <script src="comments.js"></script>
    
    <title>MSS</title>
  </head>
  <body style="height: 100%;">
    <div class="container-fluid" style="height: 100%;">
      <!-- comment form markup -->
      <div class="modal fade commentForm" id="commentForm" tabindex="-1" role="dialog" aria-hidden="true">
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
                <input type="hidden" id="docid" value="<?php echo $_GET["t"]; ?>"/>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">close</button>
                    <button type="button" class="btn btn-primary saveComment">save</button>
                </div>
            </div>
        </div>
      </div>
      <div class="row" style="height: 100%;">
        <div class="col-2">
          <div class="list-group list-group-flush" style="overflow: auto; height: 100%;">
<?php
$ms = new SimpleXMLElement("../../Transcribing/Transcriptions/transcription" . $_GET["t"] . ".xml", 0, true);
$ms->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
$uris = [];
foreach ($ms->xpath('descendant::tei:w[@lemmaRef]')  as $nextWord) {
  $pair = array($nextWord["lemma"], $nextWord['lemmaRef']);
  $uris[] = implode("|", $pair);
}

//print_r($uris); die(); 
$uris = array_unique($uris);
sort($uris,2);
foreach ($uris as $nexturi) {
//  $hw = $ms->xpath('descendant::tei:w[@lemmaRef=$nexturi]/@lemma');
  $pair = explode("|", $nexturi);
  echo '<div data-uri="' . $pair[1] . '" class="indexHeadword list-group-item list-group-item-action">' . $pair[0] . '</div>';
}


?> 
          </div>  
        </div>
        <div id="midl" class="col-5" style="overflow: auto; height: 100%;">            
<?php
$xsl = new DOMDocument;
$xsl->load('../Stylesheets/diplomatic.xsl');
$proc = new XSLTProcessor;
$proc->importStyleSheet($xsl);
echo $proc->transformToXML($ms);
?>             
        </div>
        <div id="rhs" class="col-5" style="overflow: auto; height: 100%;"> 
        </div>
      </div>
    </div>
  </body>
</html>

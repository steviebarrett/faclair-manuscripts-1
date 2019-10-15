<?php

switch ($_GET["action"]) {
  case "getEntry":    
    $entryRef = $_GET["lemmaRef"];
    $entry = Dictionary::getEntry($entryRef);
    echo json_encode($entry);
    break;
        
}

class Dictionary {

  public static function getEntry($ref) {
    $xml = simplexml_load_file("../../Transcribing/hwData.xml");
    $xml->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
    $entries = $xml->xpath("//tei:entryFree[@corresp='{$ref}']");
    $entry = $entries[0];
    $headword = $entry->w[0];
    $lemma = (string)$headword['lemma'];
    $lemmaRef = (string)$headword['lemmaRef'];
    $lemmaDW =  (string)$headword['lemmaDW'];
    $lemmaRefDW =  (string)$headword['lemmaRefDW'];
    $pos = (string)$headword['ana'];
    $forms = [];
    foreach($headword->span as $nextForm) {
      $forms[] = (string)$nextForm;
    }
    $output = array("lemma" => $lemma, "lemmaDW" => $lemmaDW, "lemmaRef" => $lemmaRef, "lemmaRefDW" => $lemmaRefDW, "pos" => $pos, "forms" => $forms);
    return $output;
  }

}
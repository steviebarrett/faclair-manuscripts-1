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
    $headword = $entry->w['lemma'];
    $output = array("headword" => $headword);
    return $output;
  }

}
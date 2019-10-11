<?php
/**
 * Created by PhpStorm.
 * User: stephenbarrett
 * Date: 16/01/2019
 * Time: 08:33
 */

define("DB_HOST", "localhost");
define("DB_NAME", "dasg");
define("DB_USER", "dasg");
define("DB_PASSWORD", "Dcraobh2106!");

switch ($_GET["action"]) {

    case "saveComment":
        $manuscript = $_GET["docid"];
        $section = $_GET["s"];
        $sectionId = $_GET["sid"];
        $comment = $_GET["comment"];
        $user = $_GET["user"];
        $saved = Manuscripts::saveComment($manuscript, $section, $sectionId, $comment, $user);
        echo json_encode($saved);
        break;
    case "deleteComment":
        $commentId = $_GET["cid"];
        $deleted = Manuscripts::deleteComment($commentId);
        echo json_encode($deleted);
        break;
    case "getComment":
        $manuscript = $_GET["docid"];
        $section = $_GET["s"];
        $sectionId = $_GET["sid"];
        $comments = Manuscripts::getCommentsById($manuscript, $section, $sectionId);
        echo json_encode($comments);
        break;
    case "getCommentInfo":
        $commentId = $_GET["cid"];
        $commentInfo = Manuscripts::getCommentIdInfo($commentId);
        echo json_encode($commentInfo);
        break;
    case "getPopulatedSections":
        $manuscript = $_GET["docid"];
        $sections = Manuscripts::getCommentSectionsByManuscriptId($manuscript);
        echo json_encode($sections);
        break;
    case "getGlyph":
        $xmlId = $_GET["xmlId"];
        $glyph = Manuscripts::getGlyph($xmlId);
        echo json_encode($glyph);
        break;
    case "getDwelly":
        $edil = $_GET["edil"];
        $dwelly = Manuscripts::getDwelly($edil);
        echo json_encode($dwelly);
        break;
    case "getTextInfo":
        echo json_encode(Manuscripts::getTextInfo($_GET["ms"], $_GET["text"]));
        break;
    case "getHandInfo":
        echo json_encode(Manuscripts::getHandInfo($_GET["hand"]));
        break;
    default:
        break;
}


class Manuscripts {

    public static function saveComment($manuscript, $section, $section_id, $comment, $user) {
        $query = <<<SQL
			INSERT INTO manuscript_comment (
			    manuscript,
				section,
                section_id,
				comment,
				user)
			VALUES (
				:manuscript,
				:section,
                :section_id,
				:comment,
				:user)
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $saved = $sth->execute(array(
            ":manuscript" => $manuscript,
            ":section" => $section,
            ":section_id" => $section_id,
            ":comment" => $comment,
            ":user" => $user
        ));
        $id = $dbh->lastInsertId();
        return array("saved" => $saved, "id" => $id);
    }

    public static function deleteComment($comment_id) {
        $query = <<<SQL
			UPDATE manuscript_comment 
            SET deleted = 1 
            WHERE id = :comment_id
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $deleted = $sth->execute(array(
            ":comment_id" => $comment_id
        ));

        $commentsInSection = self::_getNumCommentsInSection($comment_id);
        $commentsDeleted = self::_getNumCommentsDeleted($comment_id);
        return array("deleted"=>"deleted", "empty" => $commentsDeleted == $commentsInSection);
    }

    /*
     * Get the ID info (id, manuscript, section, section_id) for a comment
     * Returns an array
     */
    public static function getCommentIdInfo($comment_id) {
        $query = <<<SQL
			SELECT id, manuscript, section, section_id
            FROM manuscript_comment 
            WHERE id = :comment_id
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $sth->execute(array(
            ":comment_id" => $comment_id
        ));
        $result = $sth->fetch(PDO::FETCH_ASSOC);
        return $result;
    }

    /*
     * Checks to get count of comments in a given section that are deleted
     */
    private static function _getNumCommentsDeleted($comment_id) {
        $commentInfo = self::getCommentIdInfo($comment_id);
        $query = <<<SQL
			SELECT COUNT(deleted) as numDeleted 
            FROM `manuscript_comment` 
            WHERE `manuscript` = :manuscript AND `section` = :section AND `section_id` = :section_id AND deleted = 1;
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $sth->execute(array(
            ":manuscript" => $commentInfo["manuscript"],
            ":section" => $commentInfo["section"],
            ":section_id" => $commentInfo["section_id"]
        ));
        $result = $sth->fetch(PDO::FETCH_ASSOC);
        return $result["numDeleted"];
    }

    /*
     * Checks to get count of comments in a given section
     */
    private static function _getNumCommentsInSection($comment_id) {
        $commentInfo = self::getCommentIdInfo($comment_id);
        $query = <<<SQL
			SELECT COUNT(id) as num
            FROM `manuscript_comment`
            WHERE `manuscript` = :manuscript AND `section` = :section AND `section_id` = :section_id;
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $sth->execute(array(
            ":manuscript" => $commentInfo["manuscript"],
            ":section" => $commentInfo["section"],
            ":section_id" => $commentInfo["section_id"]
        ));
        $result = $sth->fetch(PDO::FETCH_ASSOC);
        return $result["num"];
    }


    public static function getCommentsById($manuscript, $section, $section_id) {
        $query = <<<SQL
            SELECT 
                id,
                comment,
                user,
                deleted,
                last_updated
            FROM
                manuscript_comment
            WHERE
                manuscript = :manuscript AND
                section = :section AND
                section_id = :section_id
            ORDER BY 
                last_updated DESC
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $sth->execute(array(
            ":manuscript" => $manuscript,
            ":section" => $section,
            ":section_id" => $section_id
        ));
        $result = $sth->fetchAll(PDO::FETCH_ASSOC);
        $commentInfo = array();
        foreach ($result as $fieldname => $value) {
            $commentInfo[][$fieldname] = $value;
        }
        return $commentInfo;
    }

    /*
     * Function used to find populated comment sections
     */
    public static function getCommentSectionsByManuscriptId($msId) {
        $query = <<<SQL
            SELECT
                section,
                section_id,
                deleted
            FROM
                manuscript_comment
            WHERE
                manuscript = :manuscript 
            ORDER BY
                last_updated DESC
SQL;
        $dbh = DB::getDatabaseHandle(DB_NAME);
        $sth = $dbh->prepare($query);
        $sth->execute(array(":manuscript" => $msId));
        $result = $sth->fetchAll(PDO::FETCH_ASSOC);
        $sectionInfo = array();
        foreach ($result as $fieldname => $value) {
            $sectionInfo[][$fieldname] = $value;
        }
        return $sectionInfo;
    }

    public static function getGlyph($id) {
        $xmlId = $id;
        $filepath = "../../Transcribing/corpus.xml";
        $xml = simplexml_load_file($filepath);
        $xml->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
        $nodes = $xml->xpath("/tei:teiCorpus/tei:teiHeader/tei:encodingDesc/tei:charDecl/tei:glyph[@xml:id='{$xmlId}']");
        $node = $nodes[0];
        //$xmlId = (string)$node->attributes($ns="xml", true)[0];     //the xml:id
        $corresp = (string)$node["corresp"];                  //the corresp
        $glyphName = (string)$node->glyphName;
        $note = (string)$node->note;
        $glyph = array("id" => $xmlId, "corresp" => $corresp, "name" => $glyphName, "note" => $note);
        return $glyph;
    }

    public static function getDwelly($edil) {
        $filepath = "../..//Transcribing/hwData.xml"; // change back to /mss/
        $xml = simplexml_load_file($filepath);
        $xml->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
        $nodes = $xml->xpath("/tei:TEI/tei:text/tei:body/tei:entryFree[@corresp='{$edil}']/tei:w");
        $node = $nodes[0];
        $lemmaDW = (string)$node["lemmaDW"];
        $lemmaRefDW = (string)$node["lemmaRefDW"];
        $dwelly = array("hw" => $lemmaDW, "url" => $lemmaRefDW);
        return $dwelly;
    }

    public static function getTextInfo($ms, $text) {
        $filepath = "../../Transcribing/Transcriptions/transcription" . $ms . ".xml";
        $xml = simplexml_load_file($filepath);
        $xml->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
        $text = $xml->xpath("/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItem[@xml:id='{$text}']")[0];
        return array("title" => (string)$text->title);
    }

    public static function getHandInfo($handid) {
        $filepath = "../../Transcribing/corpus.xml";
        $xml = simplexml_load_file($filepath);
        $xml->registerXPathNamespace('tei', 'http://www.tei-c.org/ns/1.0');
        $hand = $xml->xpath("/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id='{$handid}']")[0];
        $notes = array();
        foreach ($hand->note as $note) { $notes[] = $note->asXML(); }
        return array("forename" => (string)$hand->forename, "surname" => (string)$hand->surname,
            "from" => (string)$hand->date["from"], "to" => (string)$hand->date["to"],
            "min" => (string)$hand->date["min"], "max" => (string)$hand->date["max"], "region" => (string)$hand->region,
            "notes" => $notes);
    }
}

class DB
{
    private static $databaseHandle;
    const ERROR_REPORTING = true;

    private static function connect($dbName)
    {
        try {
            self::$databaseHandle = new PDO(
                "mysql:host=" . DB_HOST . ";dbname=" . $dbName . ";charset=utf8;", DB_USER, DB_PASSWORD
            );
        } catch (PDOException $e){
            echo $e->getMessage();
        }
    }

    public static function getDatabaseHandle($dbName = DB_NAME)
    {
        self::connect($dbName);

        if (self::ERROR_REPORTING)
            self::$databaseHandle->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        self::$databaseHandle->query("SET NAMES utf8");

        return self::$databaseHandle;
    }

    public static function getLastId($dbName, $tableName)
    {
        $dbh = self::getDatabaseHandle($dbName);
        $stmt = $dbh->prepare("SELECT `AUTO_INCREMENT` FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '{$dbName}' AND TABLE_NAME   = '{$tableName}'");
        $stmt->execute();
        $lastId = $stmt->fetch(PDO::FETCH_NUM);
        $lastId = $lastId[0];
        return $lastId;
    }
}
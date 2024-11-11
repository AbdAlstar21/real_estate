<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../lib/function.php";
if (
    isset($_POST["rep_id"])
    && is_numeric($_POST["rep_id"])
    && isset($_POST["rep_note"])
    
    && is_auth()
) {
	
	
    $rep_note = $_POST["rep_note"];
    $rep_id = $_POST["rep_id"];

    $updateArray = array();
    array_push($updateArray, htmlspecialchars(strip_tags($rep_note)));

	
    array_push($updateArray, htmlspecialchars(strip_tags($rep_id)));

	
		$sql = "update reports set rep_note=?,rep_datetime=now()
		where rep_id=?";
	
    $result = dbExec($sql, $updateArray);


    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../lib/function.php";
if (
    isset($_POST["realty_id"])
    && is_numeric($_POST["realty_id"])
    && is_auth()
) {
    $realty_id = $_POST["realty_id"];
    $updateArray = array();
    array_push($updateArray, htmlspecialchars(strip_tags($realty_id)));
    $sql = "update realtys set realty_fav_number = realty_fav_number - 1
    where realty_id=?";
    $result = dbExec($sql,$updateArray);

    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
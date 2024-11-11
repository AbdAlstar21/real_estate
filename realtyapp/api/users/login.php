<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../lib/function.php";
if (
    isset($_GET["user_password"])
    && isset($_GET["user_email"])
    && is_auth()
) {
    $user_password = htmlspecialchars(strip_tags($_GET["user_password"]));
    $user_email = htmlspecialchars(strip_tags($_GET["user_email"]));

    $selectArray = array();
    array_push($selectArray, $user_password);
    array_push($selectArray, $user_email);
    $sql = "select * from users where user_password = ? and user_email = ?";
    $result = dbExec($sql, $selectArray);
    $arrJson = array();
    if ($result->rowCount() > 0) {
        $arrJson  = $result->fetch();
        $resJson = array("result" => "success", "code" => "200", "message" => $arrJson);
        echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
    } else {
        //bad request
        $resJson = array("result" => "empty", "code" => "400", "message" => "empty");
        echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
    }
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
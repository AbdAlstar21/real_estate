<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../lib/create_image.php";
include_once "../../lib/function.php";
if (
    isset($_POST["user_id"])
    && is_numeric($_POST["user_id"])
    && isset($_POST["user_name"])
    && isset($_POST["user_password"])
    && isset($_POST["user_email"])
    && is_auth()
) {if (!empty($_FILES["file"]['name']) )
	{
		$images = uploadImage("file" , '../../images/users/' , 200 , 600);
		$img_image = $images["image"];
		$img_thumbnail = $images["thumbnail"];
    
	}
	else
	{
		$img_image = "";
		$img_thumbnail = "";
	}
    $user_name = $_POST["user_name"];
    $user_password = $_POST["user_password"];
    $user_email = $_POST["user_email"];
    $user_active = isset($_POST["user_active"]) ? $_POST["user_active"] : "0";
    $user_note = isset($_POST["user_note"]) ? $_POST["user_note"] : "";
    $user_id = $_POST["user_id"];

    $updateArray = array();
    array_push($updateArray, htmlspecialchars(strip_tags($user_name)));
    array_push($updateArray, htmlspecialchars(strip_tags($user_password)));
    array_push($updateArray, htmlspecialchars(strip_tags($user_email)));
    array_push($updateArray, htmlspecialchars(strip_tags($user_active)));
    array_push($updateArray, htmlspecialchars(strip_tags($user_note)));
    
	if($img_image != "")
	{
		array_push($updateArray, htmlspecialchars(strip_tags($img_image)));
		array_push($updateArray, htmlspecialchars(strip_tags($img_thumbnail)));
	}
    array_push($updateArray, htmlspecialchars(strip_tags($user_id)));
    if($img_image != "")
	{
		
        $sql = "update users set user_name=?,user_password=?,user_email=?,user_active=?,user_note=?,user_lastdate=now(), user_image = ? , user_thumbnail = ?
        where user_id=?";
	}
	else
	{
		
        $sql = "update users set user_name=?,user_password=?,user_email=?,user_active=?,user_note=?,user_lastdate=now()
        where user_id=?";
	}


    $result = dbExec($sql, $updateArray);

    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
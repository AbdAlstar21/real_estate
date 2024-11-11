<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../lib/function.php";
include_once "../../lib/create_image.php";
if (
    isset($_POST["cat_id"])
    && is_numeric($_POST["cat_id"])
    && isset($_POST["cat_name"])
    
    && is_auth()
) {
		if (!empty($_FILES["file"]['name']) )
	{
		$images = uploadImage("file" , '../../images/categories/' , 200 , 600);
		$img_image = $images["image"];
		$img_thumbnail = $images["thumbnail"];
    
	}
	else
	{
		$img_image = "";
		$img_thumbnail = "";
	}

	
    $cat_name = $_POST["cat_name"];
    $cat_id = $_POST["cat_id"];

    $updateArray = array();
    array_push($updateArray, htmlspecialchars(strip_tags($cat_name)));

	if($img_image != "")
	{
		array_push($updateArray, htmlspecialchars(strip_tags($img_image)));
		array_push($updateArray, htmlspecialchars(strip_tags($img_thumbnail)));
	}
    array_push($updateArray, htmlspecialchars(strip_tags($cat_id)));

	if($img_image != "")
	{
		$sql = "update categories set cat_name=?, cat_image = ? , cat_thumbnail = ? ,cat_date=now()
		where cat_id=?";
	}
	else
	{
		$sql = "update categories set cat_name=?,cat_date=now()
		where cat_id=?";
	}
    $result = dbExec($sql, $updateArray);


    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
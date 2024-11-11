<?php
 header("Access-Control-Allow-Origin: *");
 header("Content-Type: application/json; charset=UTF-8");
 include_once "../../lib/create_image.php";
 include_once "../../lib/function.php";

if (
  
    isset($_POST["user_name"])
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
    $user_active = "0";
    $user_note = isset($_POST["user_note"]) ? $_POST["user_note"] : "";
    $user_token = $_POST["user_token"];
    $insertArray = array();
    array_push($insertArray, htmlspecialchars(strip_tags($user_name)));
    array_push($insertArray, htmlspecialchars(strip_tags($user_password)));
    array_push($insertArray, htmlspecialchars(strip_tags($user_email)));
    array_push($insertArray, htmlspecialchars(strip_tags($user_active)));
    array_push($insertArray, htmlspecialchars(strip_tags($user_note)));
    array_push($insertArray, htmlspecialchars(strip_tags($user_token)));
    array_push($insertArray, htmlspecialchars(strip_tags($img_image)));
    array_push($insertArray, htmlspecialchars(strip_tags($img_thumbnail)));
    $sql = "insert into users(user_name , user_password , user_email , user_active , user_note , user_datetime , user_lastdate,user_token,user_image,user_thumbnail)
            values(? , ? , ? , ? 
            ,? , now() , now(),?,?,?)";
    $result = dbExec($sql, $insertArray);

    $readArray = array();
    array_push($readArray, htmlspecialchars(strip_tags($user_email)));
	
    $sql = "select * from users where user_email = ?  order by user_id desc limit 0,1";
    $result = dbExec($sql, $readArray);
    $arrJson = array();
    if ($result->rowCount() > 0) {
        $arrJson  = $result->fetch();
	}

    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
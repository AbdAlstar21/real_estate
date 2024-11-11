<?php
 header("Access-Control-Allow-Origin: *");
 header("Content-Type: application/json; charset=UTF-8");
 include_once "../../lib/create_image.php";
 include_once "../../lib/function.php";
if ( 
        isset($_POST["realty_short_title"])
    //  && isset($_POST["realty_publisher"])
    //  && isset($_POST["number_phone"])
    //  && isset($_POST["realty_type"])
    //  && isset($_POST["realty_summary"])
     && is_auth() 
    
) {
    if (!empty($_FILES["file"]['name']) )
	{
		$images = uploadImage("file" , '../../images/realtys/' , 200 , 600);
		$img_image = $images["image"];
		$img_thumbnail = $images["thumbnail"]; 
        
	}
	else
	{
		$img_image = "";
		$img_thumbnail = "";
	}
    // if (!empty($_FILES["myfile"]['name']))
	// { 
    //     $myFile = $_FILES['myfile']['name']; 
    //     $myFileTmpName =$_FILES["myfile"]["tmp_name"];
    //     $upLoadFolder= "../../files/".$myFile; 
    //     move_uploaded_file($myFileTmpName,$upLoadFolder);
	// }
	// else
	// {
	// 	$myFile = "";
	// }
    $cat_id = $_POST["cat_id"];
    // $user_id = $_POST["user_id"];
    
    $realty_short_title = $_POST["realty_short_title"];
    $number_phone = $_POST["number_phone"];
    $realty_type = $_POST["realty_type"];
    $realty_block = isset($_POST["realty_block"]) ? $_POST["realty_block"] : "0";
    $realty_summary =$_POST["realty_summary"];
    $realty_token = $_POST["realty_token"];

    $realty_fav_number=0;
    $realty_publisher = $_POST["realty_publisher"];
    $realty_price = $_POST["realty_price"];
    

    $insertArray = array();
    array_push($insertArray, htmlspecialchars(strip_tags($cat_id)));
    // array_push($insertArray, htmlspecialchars(strip_tags($user_id)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_short_title)));
    array_push($insertArray, htmlspecialchars(strip_tags($number_phone)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_type)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_block)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_summary)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_token)));
    array_push($insertArray, htmlspecialchars(strip_tags($img_image)));
    array_push($insertArray, htmlspecialchars(strip_tags($img_thumbnail)));
    // array_push($insertArray, htmlspecialchars(strip_tags($myFile)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_fav_number)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_publisher)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_price)));
    

    $sql = "insert into realtys(cat_id , realty_short_title , number_phone , realty_type , realty_block, realty_summary , realty_date , realty_token , realty_image , realty_thumbnail  , realty_fav_number , realty_publisher , realty_price)
            values(? , ? , ? , ? , ? , ? , now() , ? , ? , ? , ? , ? , ?)";
    $result = dbExec($sql, $insertArray);

    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
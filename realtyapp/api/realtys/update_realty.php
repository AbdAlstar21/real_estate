<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../lib/create_image.php";
include_once "../../lib/function.php";
if (
    isset($_POST["realty_id"])
    && is_numeric($_POST["realty_id"])
    // && isset($_POST["realty_short_title"])
    // && isset($_POST["number_phone"])
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
    
    $realty_short_title = $_POST["realty_short_title"];
    $number_phone = $_POST["number_phone"];
    $realty_type = $_POST["realty_type"];
    $realty_price = $_POST["realty_price"];
    $realty_block = isset($_POST["realty_block"]) ? $_POST["realty_block"] : "0";
    $realty_summary =$_POST["realty_summary"];
    // $book_file = isset($_POST["book_file"]) ? $_POST["book_file"] : "";
    // $book_price = isset($_POST["book_price"]) ? $_POST["book_price"] : "";
    $realty_id = $_POST["realty_id"];
    $cat_id = $_POST["cat_id"];

    $updateArray = array();
    array_push($updateArray, htmlspecialchars(strip_tags($realty_short_title)));
    array_push($updateArray, htmlspecialchars(strip_tags($number_phone)));
    array_push($updateArray, htmlspecialchars(strip_tags($realty_type)));
    array_push($updateArray, htmlspecialchars(strip_tags($realty_price)));
    array_push($updateArray, htmlspecialchars(strip_tags($realty_block)));
    array_push($updateArray, htmlspecialchars(strip_tags($realty_summary)));
    array_push($updateArray, htmlspecialchars(strip_tags($cat_id)));
    if($img_image != "")
	{
		array_push($updateArray, htmlspecialchars(strip_tags($img_image)));
		array_push($updateArray, htmlspecialchars(strip_tags($img_thumbnail)));
	
    }

    array_push($updateArray, htmlspecialchars(strip_tags($realty_id)));

    if($img_image != "")
	{
        $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_price=?,realty_block=?,realty_summary=?,realty_date=now(),cat_id = ? ,realty_image = ? , realty_thumbnail = ?
        where realty_id=?";
	}
	else
	{
        $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_price=?,realty_block=?,realty_summary=?,realty_date=now(),cat_id = ?
        where realty_id=?";
	}


    // $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_block=?,realty_summary=?,realty_date=now()
    // where realty_id=?";


    $result = dbExec($sql, $updateArray);

    $resJson = array("result" => "success", "code" => "200", "message" => "done");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
// header("Access-Control-Allow-Origin: *");
// header("Content-Type: application/json; charset=UTF-8");
// include_once "../../lib/create_image.php";
// include_once "../../lib/function.php";
// if (
//     isset($_POST["realty_id"])
//     && is_numeric($_POST["realty_id"])
//     // && isset($_POST["realty_short_title"])
//     // && isset($_POST["number_phone"])
//     //  && isset($_POST["realty_type"])
//     //  && isset($_POST["realty_summary"])
//     && is_auth()
// ) {
//     if (!empty($_FILES["file"]['name']) )
// 	{
// 		$images = uploadImage("file" , '../../images/realtys/' , 200 , 600);
// 		$img_image = $images["image"];
// 		$img_thumbnail = $images["thumbnail"]; 
        
// 	}
// 	else
// 	{
// 		$img_image = "";
// 		$img_thumbnail = "";
// 	}
    
//     $realty_short_title = $_POST["realty_short_title"];
//     $number_phone = $_POST["number_phone"];
//     $realty_type = $_POST["realty_type"];
//     // $realty_block = isset($_POST["realty_block"]) ? $_POST["realty_block"] : "0";
//     $realty_summary =$_POST["realty_summary"];
   
//     $realty_price = $_POST["realty_price"];
//     $realty_id = $_POST["realty_id"];
//     $cat_id = $_POST["cat_id"];

//     $updateArray = array();
//     array_push($updateArray, htmlspecialchars(strip_tags($realty_short_title)));
//     array_push($updateArray, htmlspecialchars(strip_tags($number_phone)));
//     array_push($updateArray, htmlspecialchars(strip_tags($realty_type)));
//     // array_push($updateArray, htmlspecialchars(strip_tags($realty_free)));
//     // array_push($updateArray, htmlspecialchars(strip_tags($realty_block)));
//     array_push($updateArray, htmlspecialchars(strip_tags($realty_summary)));
        
//     if($img_image != "")
// 	{
// 		array_push($updateArray, htmlspecialchars(strip_tags($img_image)));
// 		array_push($updateArray, htmlspecialchars(strip_tags($img_thumbnail)));
	
//     }
//     array_push( $updateArray, htmlspecialchars(strip_tags($realty_price)));
//     array_push($updateArray, htmlspecialchars(strip_tags($cat_id)));
//     array_push($updateArray, htmlspecialchars(strip_tags($realty_id)));

//     if($img_image != "")
// 	{
//         $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_summary=?,realty_date=now(),realty_image = ? , realty_thumbnail = ? , realty_price = ? ,cat_id = ? 
//         where realty_id=?";
// 	}
// 	else
// 	{
//         $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_block=?,realty_summary=?,realty_date=now() , realty_price = ? ,  cat_id = ? 
//         where realty_id=?";
// 	}


//     // $sql = "update realtys set realty_short_title=?,number_phone=?,realty_type=?,realty_block=?,realty_summary=?,realty_date=now()
//     // where realty_id=?";


//     $result = dbExec($sql, $updateArray);

//     $resJson = array("result" => "success", "code" => "200", "message" => "done");
//     echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
// } else {
//     //bad request
//     $resJson = array("result" => "fail", "code" => "400", "message" => "error");
//     echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
// }
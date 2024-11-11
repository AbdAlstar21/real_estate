   <?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once "../../lib/function.php";

if (
    isset($_POST["rep_note"])
    &&
    isset($_POST["user_id"])
    && isset($_POST["realty_id"])
    && is_auth()  
) {
    $user_id = $_POST["user_id"];
    $realty_id = $_POST["realty_id"];
    $rep_note = $_POST["rep_note"];
    $realty_short_title=$_POST["realty_short_title"];
	
	

    $insertArray = array();
    array_push($insertArray, htmlspecialchars(strip_tags($user_id)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_id)));
    array_push($insertArray, htmlspecialchars(strip_tags($rep_note)));
    array_push($insertArray, htmlspecialchars(strip_tags($realty_short_title)));

    $sql = "insert into reports(user_id , realty_id , rep_note , rep_datetime , realty_short_title)
            values(? , ? , ? , now() , ?)";
    $result = dbExec($sql, $insertArray);

	  $readArray = array();
	
    array_push($readArray, htmlspecialchars(strip_tags($user_id)));
	array_push($readArray, htmlspecialchars(strip_tags($realty_id)));
	
    $sql = "select * from reports where user_id = ? and realty_id = ?  order by realty_id desc limit 0,1";
    $result = dbExec($sql, $readArray); 
    $arrJson = array();
    if ($result->rowCount() > 0) {
        $arrJson  = $result->fetch();
	}
    $resJson = array("result" => "success", "code" => "200", "message" => $arrJson);
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
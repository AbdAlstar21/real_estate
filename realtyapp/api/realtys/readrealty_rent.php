<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../lib/function.php";
if (
    isset($_GET["start"])
    && is_numeric($_GET["start"])
    && isset($_GET["end"])
    && is_numeric($_GET["end"])
	&& isset($_GET["user_id"])
    && is_numeric($_GET["user_id"])
    && is_auth()
) {
    $start = $_GET["start"];
    $end = $_GET["end"];
	$user_id = $_GET["user_id"];
	$sqlWhere = "";
	if( 
   isset($_GET["cat_id"])&& 
   is_numeric($_GET["cat_id"]))
	{
		$cat_id = $_GET["cat_id"];
		$sqlWhere = " and  cat_id = $cat_id ";
	}
	$txtsearch = !isset($_GET["txtsearch"])   ? "" : $_GET["txtsearch"]  ;
 	$selectArray = array();
	
    array_push($selectArray, "%" . htmlspecialchars(strip_tags($txtsearch)) . "%");
	if(trim($txtsearch) != "")
	{
		$sql = "select * 
		, (select fav_id from favorite where realty_id = realtys.realty_id and user_id = $user_id ) as fav_id 
		, (select rep_id from reports where realty_id = realtys.realty_id and user_id = $user_id ) as rep_id 
		
		from realtys where realty_type='آجار' and realty_short_title like ? $sqlWhere  order by realty_id asc limit $start , $end";
		$result = dbExec($sql, $selectArray);
	}
	else
	{
		$sql = "select * 
		, (select fav_id from favorite where realty_id = realtys.realty_id and user_id = $user_id ) as fav_id 
		, (select rep_id from reports where realty_id = realtys.realty_id and user_id = $user_id ) as rep_id 
		
		from realtys where realty_type='آجار' and  1 = 1 $sqlWhere order by realty_id asc limit $start , $end";
	
		$result = dbExec($sql, []);
		$result = dbExec($sql, []);
	}
    $arrJson = array();
    if ($result->rowCount() > 0) {
        while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
            // extract($row);
            $arrJson[] = $row;
        }
    }
    $resJson = array("result" => "success", "code" => "200", "message" => $arrJson);
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
} else {
    //bad request
    $resJson = array("result" => "fail", "code" => "400", "message" => "error");
    echo json_encode($resJson, JSON_UNESCAPED_UNICODE);
}
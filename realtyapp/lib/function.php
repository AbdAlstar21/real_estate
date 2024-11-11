<?php

include_once "database.php";
const token = "dnmnvzxtn2ddfhjhdsgfjsfbsajlarbsbmsbfsb5688";
function dbExec($sql, $param_array)
{
    $database = new Database();
    $database->getConnection();
    $myCon = $database->conn;
    $stmt = $myCon->prepare($sql);
    $stmt->execute($param_array);
    return $stmt;
}

function is_auth()
{
    if (isset($_GET["token"]) && $_GET["token"] == token) {
        return true;
    } else {
        return false;
    }
}


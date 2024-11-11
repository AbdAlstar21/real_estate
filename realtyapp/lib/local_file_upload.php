<?php 
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
include_once "config.php";

$return["error"] = false;
$return["msg"] = "";
$return["success"] = false;
//array to return

if(isset($_FILES["file"])){
    //directory to upload file
    $target_dir = "files/"; //create folder files/ to save file
    $filename = $_FILES["file"]["name"]; 
    $newFileName=substr($myFile,0,(strrpos($myFile,".")));
    var_dump($newFileName);

    //name of file
    //$_FILES["file"]["size"] get the size of file
    //you can validate here extension and size to upload file.

    $savefile = "$target_dir$filename";
    //complete path to save file

    if(move_uploaded_file($_FILES["file"]["tmp_name"], $savefile)) {
       $uploud =$conn ->query("insert into files(file_url,file_name)
            values('$filename','$newFileName')");

            if($uploud)
            {
                echo json_encode("upload sucsses");

            }
            else
            {
                echo json_encode("upload faild".mysqli_errno($conn));
            }
        $return["error"] = false;
        //upload successful
    }else{
        $return["error"] = true;
        $return["msg"] =  "Error during saving file.";
    }
}else{
    $return["error"] = true;
    $return["msg"] =  "No file is sublitted.";
}

header('Content-Type: application/json');
// tell browser that its a json data
echo json_encode($return);
//converting array to JSON string
?>
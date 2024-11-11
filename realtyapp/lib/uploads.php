<?php 
include_once "config.php";

 $myFile = $_FILES["file"]["name"]; 
 $myFileTmpName =$_FILES["file"]["tmp_name"];
 $newFileName=substr($myFile,0,(strrpos($myFile,".")));
 var_dump($newFileName);
 $upLoadFolder= "files/".$myFile; 
 move_uploaded_file($myFileTmpName,$upLoadFolder);

 $uploud =$conn ->query("insert into files(file_url,file_name)
            values('$myFile','$newFileName')");

            if($uploud)
            {
                echo json_encode("upload sucsses");

            }
            else
            {
                echo json_encode("upload faild".mysqli_errno($conn));
            }
    
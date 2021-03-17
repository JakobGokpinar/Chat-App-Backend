<?php
    require 'connection.php';
    require 'checklog.php';

    $status = $statusMsg = ''; 
    $status = 'error'; 

    if(!empty($_FILES["photo"]["name"])) { 
        // Get file info 
        $fileName = basename($_FILES["photo"]["name"]); 
        $fileType = pathinfo($fileName, PATHINFO_EXTENSION); 
         
        // Allow certain file formats 
        $allowTypes = array('jpg','png','jpeg','gif'); 
        if(in_array($fileType, $allowTypes)){ 
            $image = $_FILES['photo']['tmp_name']; 
            $imgContent = addslashes(file_get_contents($image)); 
         
            // Insert image content into database 
            $insert = $connection->query("UPDATE users SET photo = '$imgContent' WHERE username='$username'"); 
            //$insert = true;
            if($insert){ 
                $status = 'success'; 
                $statusMsg = "File uploaded successfully."; 
            }else{ 
                $statusMsg = "File upload failed, please try again."; 
            }  
        }else{ 
            $statusMsg = 'Sorry, only JPG, JPEG, PNG, & GIF files are allowed to upload.'; 
        } 
    }else{ 
        $statusMsg = 'Please select an image file to upload.'; 
    } 
 
 
// Display status message 
echo $statusMsg;
?>
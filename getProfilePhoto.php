<?php
    /*Gets a user's profile photo.

    Users' profile photos are stored under 'users' folder by name.
    When a user changes his default photo, default.jpg, a new folder with the new photo is created.
    */

    require('connection.php');
    //require('checklog.php');

    $user = $_GET["username"];

    $imgDir = "photos/image.jpg";
    $defaultImgDir = "photos/default.jpg";

    $images = null; 

    $file = fopen($imgDir,'w');

    $result = mysqli_query($connection, "SELECT photo FROM users WHERE username='$user'");

    while($row = mysqli_fetch_assoc($result)){
        if($row["photo"] != null || $row["photo"] != false){
            file_put_contents($imgDir, $row["photo"]);
            $images = glob($imgDir, GLOB_BRACE); //get the file with user's photo..
            
        }
        else{
            $images = glob($defaultImgDir, GLOB_BRACE); //get the file with user's photo..
        }
    }
    
    $images = $images[0];

    $fp = fopen($images, 'rb'); //open the file.

    header("Content-Type: image/png");
    header("Content-Length: " . filesize($images));

    fpassthru($fp); //Output all remaining data on a file pointer
    
?>
<?php
    /*Gets a user's profile photo.

    Users' profile photos are stored under 'users' folder by name.
    When a user changes their default photo, default.jpg, a new folder with the new photo is created.
    */

    require('connection.php');
    #require('checklog.php');

    $username = $_GET["username"];  //The user whose profile photo will get.

    if (!isset($_GET["username"])) { //Check if the username has been obtained correctly.
        echo "not found";
        exit();
    }

    $rawDir = "users/";
    $directory = $rawDir . $username;   //directory of the photo

    $images = null; //File which contains the photo.
    
    if (!file_exists($directory)) {   //if there is no folder with the username, get the default image file.
        $images = glob($rawDir."default.jpg", GLOB_BRACE);
    }else{ 
        $images = glob($directory. "/*.{jpg,png,bmp}", GLOB_BRACE); //get the file with user's photo..
    }
    $images = $images[0];

    $fp = fopen($images, 'rb'); //open the file.

    header("Content-Type: image/png");
    header("Content-Length: " . filesize($images));

    fpassthru($fp); //Output all remaining data on a file pointer
    
?>
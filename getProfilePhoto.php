<?php
    require('connection.php');
    #require('checklog.php');

    
    $username = $_GET["username"];
    if (!isset($_GET["username"])) {
        echo "not found";
        exit();
    }
    $rawDir = "users/";
    $directory = $rawDir . $username;

    $images = null;
    
    if (!file_exists($directory)) {   
        $images = glob($rawDir."default.jpg", GLOB_BRACE);
    }else{ 
        $images = glob($directory. "/*.{jpg,png,bmp}", GLOB_BRACE);
    }
    $images = $images[0];

    $fp = fopen($images, 'rb');

    header("Content-Type: image/png");
    header("Content-Length: " . filesize($images));

    fpassthru($fp);
    
?>
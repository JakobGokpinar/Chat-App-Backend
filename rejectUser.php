<?php
    //Blocks a user when its request gets rejected in frontend.
    require 'connection.php';
    require 'checklog.php';

    $blocker = mysqli_real_escape_string($connection, $username); //$blocker = logged in user
    $blocked = mysqli_real_escape_string($connection, $_POST["blockedUser"]); //$blocked user received with post request 
    $result = mysqli_query($connection, "CALL rejectUser('$blocker','$blocked')");

    if($result !== false){
        echo "rejection successful";
    } else {
        echo "rejection unsuccessful";
    }
?>
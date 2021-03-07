<?php
    require 'connection.php';   
    require 'checklog.php';

    $receiverUser = mysqli_real_escape_string($connection, $_POST["receiverUser"]);
    $senderUser = mysqli_real_escape_string($connection, $_SESSION["loggedUser"]);

    
    $resultfriends = mysqli_query($connection, "SELECT * FROM friends WHERE (person1 = '$senderUser' AND person2 = '$receiverUser') OR (person1 = '$receiverUser' AND person2 = '$senderUser')");
    $resultrequests = mysqli_query($connection, "SELECT * FROM requeststable WHERE sender='$senderUser' AND receiver='$receiverUser'");
    $resultblock = mysqli_query($connection, "SELECT * FROM blacklist WHERE blocker='$receiverUser' AND blocked='$senderUser'");

    //Check if they are alrady friends
    if(mysqli_fetch_assoc($resultfriends) === null){
        //Check if sender is blocked by receiver
        if(mysqli_fetch_assoc($resultblock) === null){
            //Check if sender already sent a request
            if(mysqli_fetch_assoc($resultrequests) === null){
                mysqli_query($connection, "INSERT INTO requeststable (sender,receiver) VALUES ('$senderUser', '$receiverUser')");
                echo "request sent";
            } 
            else {        
                echo "already sent";
            }
        } 
        else {
            echo "blocked user";
        }    
    } 
    else {
        echo "already friends";     
    }
?>
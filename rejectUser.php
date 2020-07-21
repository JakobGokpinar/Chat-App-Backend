<?php
    require 'connection.php';
    require 'checklog.php';

    $blocker = mysqli_real_escape_string($connection, $username);
    $blocked = mysqli_real_escape_string($connection, $_POST["blockedUser"]);
    $result = mysqli_query($connection, "CALL rejectUser('$blocker','$blocked')");

    if($result !== false){
        echo "rejection successful";
    } else {
        echo "rejection unsuccessful";
    }
?>
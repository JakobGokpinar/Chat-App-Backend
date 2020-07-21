<?php
    require 'connection.php';
    require 'checklog.php';

    $username = mysqli_real_escape_string($connection, $username);
    $result = mysqli_query($connection, "CALL changeProfilePhoto('$username','$blocked')");
    if($result !== false){
        echo "photo changed";
    } else {
        echo "photo not changed";
    }
?>
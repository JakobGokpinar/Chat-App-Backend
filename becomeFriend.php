<?php
    require 'connection.php';
    require 'checklog.php';

    $adder = mysqli_real_escape_string($connection, $username);
    $added = mysqli_real_escape_string($connection, $_POST["added"]);
    $result = mysqli_query($connection, "CALL addFriend('$adder','$added')");
    if($result !== false){
        echo "addfriend successful";
    } else {
        echo "addfriend unsuccessful";
    }
?>
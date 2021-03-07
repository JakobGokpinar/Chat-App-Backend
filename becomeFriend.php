<?php
    require 'connection.php'; //check database connection
    require 'checklog.php'; //check if user is logged in

    $adder = mysqli_real_escape_string($connection, $username); //makes the string suitable for mysql query.
    $added = mysqli_real_escape_string($connection, $_POST["added"]); //makes the string suitable for mysql query.
    $result = mysqli_query($connection, "CALL addFriend('$adder','$added')"); //calls mysql procedure addFriend() and gives the parameters, adder and added.
    
    if($result !== false){
        echo "addfriend successful";
    } else {
        echo "addfriend unsuccessful";
    }
?>
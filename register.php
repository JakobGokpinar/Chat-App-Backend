<?php
    require 'connection.php';
    $username = mysqli_real_escape_string($connection, $_POST["username"]);
    $password = mysqli_real_escape_string($connection, $_POST["password"]);
    $result = mysqli_query($connection, "INSERT INTO users (username,password) VALUES('$username','$password')");
    if($result !== false){
        echo "register successful";
    } else {
        echo "register unsuccessful";
    }
?>
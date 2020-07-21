<?php
    require 'connection.php';

    // Safety measure: do not store old user information!
    session_destroy(); 
    session_start(); 

    $username = mysqli_real_escape_string($connection, $_POST["username"]);
    $password = mysqli_real_escape_string($connection, $_POST["password"]);
    $result = mysqli_query($connection, "SELECT * FROM users WHERE username = '$username' AND password = '$password'");
    if(mysqli_fetch_assoc($result) !== null){
        $_SESSION['loggedIn'] = true;
        $_SESSION['loggedUser'] = $username;
        echo "login successful";
    } else {
        echo "login unsuccessful";
    }
?>

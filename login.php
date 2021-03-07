<?php
    require 'connection.php';

    // Safety measure: do not store old user information!
    session_destroy(); 
    session_start(); 
    $username = mysqli_real_escape_string($connection, $_POST["username"]);
    $password = mysqli_real_escape_string($connection, $_POST["password"]);

    //Check if the username and password matches
    $result = mysqli_query($connection, "SELECT * FROM users WHERE username = '$username' AND password = '$password'"); 

    if(mysqli_fetch_assoc($result) !== null){
        $_SESSION['loggedIn'] = true; //Create loggedIn session and make it true.
        $_SESSION['loggedUser'] = $username; //Create loggedUser session which equals to current logged in user.
        echo "login successful";
    } else {
        $_SESSION['loggedIn'] = false;
        echo "login unsuccessful";
    }
?>

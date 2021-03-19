<?php
    //check if the user is logged in to use the application.
    require 'connection.php';

    if(!isset(($_SESSION["loggedIn"]))){
        echo "not logged in";
        exit();
    }

    $username = $_SESSION["loggedUser"]; //Global variable $username which is taken from loggedUser session from login.php
?>
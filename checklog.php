<?php

    if(!isset($_SESSION["loggedIn"])){
        echo "not logged in";
        exit();
    }

    $username = $_SESSION["loggedUser"];
    
?>
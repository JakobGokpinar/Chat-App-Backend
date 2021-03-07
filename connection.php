<?php

    #$connection = mysqli_connect('localhost:3306', 'root', '', 'goksoft chat app');
    $connection = mysqli_connect('us-cdbr-east-02.cleardb.com:3306', 'bfca2adbd98d3d', 'ebebb0b8', 'heroku_77553a4fbd53445');
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

?>
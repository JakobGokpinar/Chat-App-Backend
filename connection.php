<?php

    $connection = mysqli_connect('localhost:3306', 'root', '', 'goksoft chat app');
    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
?>
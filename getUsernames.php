<?php
    require 'connection.php';
    if(!$_SESSION["loggedIn"]){
        echo "not logged in";
        return;
    }
    
    $username = mysqli_real_escape_string($connection, $_POST["username"]);
    $sql = "SELECT username FROM users ORDER BY username"; 
    $result = mysqli_query($connection, $sql);
    $array = array();
    
    // Her satırı alıyo
    while ($row = mysqli_fetch_assoc($result)) {
        $currname = $row["username"];

        // $username $curname içinde ise if bloğunu çalıştır
        if(strstr($currname, $username != "" ? $username : "EMPTY")){
            if (strpos($currname, $_SESSION["loggedUser"]) === false) {
                array_push($array, $currname);
            }
        }
    }
  
    $aray = array_slice($array, 0, 20);
    echo json_encode($array);
    // possible return: {["ahmetgkp", "hakancandar", "altan", "omerteta"]}
?>
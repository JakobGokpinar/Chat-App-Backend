<?php
    //Gets all users' usernames in order to use in user search.
    require 'connection.php';
    require 'checklog.php';
    
    //Make the username proper for sql query.
    $username = mysqli_real_escape_string($connection, $_POST["username"]); //$username = typed characters in frontend.
    $sql = "SELECT username FROM users ORDER BY username"; //SQL query command.
    $result = mysqli_query($connection, $sql);  //Execute the query and get the returned datas.
    $array = array();
    
    // Take each row from returned datas.
    while ($row = mysqli_fetch_assoc($result)) {
        $currname = $row["username"];

        // Execute the if statement if $currname includes the $username
        if(strstr($currname, $username != "" ? $username : "EMPTY")){
            if (strpos($currname, $_SESSION["loggedUser"]) === false) { //Filter logged in user
                array_push($array, $currname);  //Add the current user into the $array array.
            }
        }
    }
  
    $array = array_slice($array, 0, 20); //Return 20 names from the array.
    echo json_encode($array);
    // possible return: {["ahmetgkp", "hakancandar", "altan", "omer"]}
?>
<?php
    //Gets the messages between to users.

    require 'connection.php';
    require 'checklog.php';

    $receiver = mysqli_real_escape_string($connection, $_POST["receiver"]); //get receiver(chatted friend) from frontend.

    //call getMessage() procedure where sender is logged in user and receiver is the chatted friend that taken with post request.
    $result = mysqli_query($connection, "CALL getMessage('$username', '$receiver')"); 
    mysqli_next_result($connection);
    $result2 = mysqli_query($connection, "CALL setNotification('$username', '$receiver', 0)");
    $array = array();    

    function utf8ize($d) {
        if (is_array($d)) {
            foreach ($d as $k => $v) {
                $d[$k] = utf8ize($v);
            }
        } else if (is_string ($d)) {
            return utf8_decode($d);
        }
        return $d;
    }


    while($row = mysqli_fetch_assoc($result)){
        array_push($array, array($row["sender"], $row["msg"]));
    }
    
    echo json_encode(utf8ize($array));
?>  
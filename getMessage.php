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
    $var = 0;
    

    while($row = mysqli_fetch_assoc($result)){
        if($var <= 180){
            array_push($array, array($row["sender"], $row["msg"]));

        }
        $var += 1;
    }
    
    
    echo json_encode($array);
?>  
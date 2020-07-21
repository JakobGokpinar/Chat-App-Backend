<?php
    require 'connection.php';
    require 'checklog.php';

    $receiver = mysqli_real_escape_string($connection, $_POST["receiver"]);
    
    $result = mysqli_query($connection, "CALL getMessage('$username', '$receiver')");
    mysqli_next_result($connection);
    $result2 = mysqli_query($connection, "CALL setNotification('$username', '$receiver', 0)");
    $array = array();
    
    while($row = mysqli_fetch_assoc($result)){
        array_push($array, array($row["sender"], $row["msg"]));

    }
    
    echo json_encode($array);

?>  
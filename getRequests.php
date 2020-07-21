<?php
    require 'connection.php';
    require 'checklog.php';

    $username = mysqli_real_escape_string($connection, $username);
    $result = mysqli_query($connection, "CALL getRequests('$username')");
    $requests = array();

    while($row = mysqli_fetch_assoc($result)){
        array_push($requests, $row["request"]);
    }

    echo json_encode($requests);

?>
<?php
    //Gets the notification count between the user and chatted friend.

    require 'connection.php';
    require 'checklog.php';

    $chatter = mysqli_real_escape_string($connection, $_POST["chatter"]);

    $result = mysqli_query($connection, "CALL getNotification('$username', '$chatter')");

    $row = mysqli_fetch_assoc($result);
    echo $row["counts"];
?>
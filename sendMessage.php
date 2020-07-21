    <?php
    require 'connection.php';
    require 'checklog.php';
    
    $receiver = mysqli_real_escape_string($connection, $_POST["receiver"]);
    $message = mysqli_real_escape_string($connection, $_POST["message"]);
    
    $result = mysqli_query($connection, "CALL sendMessage('$username', '$receiver', '$message')");

    if($result !== false){
        echo "message sent";
    } else {
        echo "message not sent";
    }
    echo mysqli_error($connection);
?>
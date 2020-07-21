<?php
    require 'connection.php';
    require 'checklog.php';

    $username = mysqli_real_escape_string($connection, $username);
    $result = mysqli_query($connection, "CALL getFriends('$username')");
    $requests = array();

    while($row = mysqli_fetch_assoc($result)){
        $timediff = explode(":", $row["lastdate"]);
        $strdiff = "";
        if($timediff[0] == "no date")
            $strdiff = "cCc";
        else if($timediff[0] > 24){
            $strdiff = "" . floor($timediff[0] / 24) . " d";
            if(intval(explode(" ", $strdiff)[0]) < 5){
                if(intval(explode(" ", $strdiff)[0]) == 1){
                    $strdiff = "Yesterday";
                } else{
                    $date = date("D",strtotime("-" . explode(" ", $strdiff)[0] . " day"));
                    $strdiff = $date;
                }
            }
        }
        else if($timediff[0] >= 1)
            $strdiff = "" . intval($timediff[0]) . " h";
        else if($timediff[1] >= 1)
            $strdiff = "" . intval($timediff[1]) . " m";
        else
            $strdiff = "Now";

        array_push($requests, array($row["friend"], $row["counts"],$row["lastmsg"], $strdiff));
    }
    
    echo json_encode($requests);

?>
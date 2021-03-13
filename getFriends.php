<?php
    require 'connection.php'; //check database connection
    require 'checklog.php'; //check if user is logged in

    $username = mysqli_real_escape_string($connection, $username);  //makes the string suitable for mysql query.
    $result = mysqli_query($connection, "CALL getFriends('$username')");    //calls mysql procedure getFriends() and gives a parameter, username.
    $requests = array();    //creates an array to store returned datas from query, $result.

    while($row = mysqli_fetch_assoc($result)){ 
       // echo $row["lastdate"];}  
        //mysqli_fetch_assoc returns each data set as row that comes from $result query.
    $timediff = explode(":", $row["lastdate"]); //get lastdate value in datetime type and parse by :
        $strdiff = "";
        if($timediff[0] == "no date")
            $strdiff = " ";
        else if($timediff[0] > 24){ //if 1 or more days have passed since last message
            $strdiff = "" . floor($timediff[0] / 24) . " d";
            if(intval(explode(" ", $strdiff)[0]) < 5){
                if(intval(explode(" ", $strdiff)[0]) == 1){
                    $strdiff = "Yesterday";
                } else{
                    $date = date("D",strtotime("-" . explode(" ", $strdiff)[0] . " day"));  //create a date showing how many days has passed in D (days) format
                    $strdiff = $date;
                }
            }
        }
        else if($timediff[0] >= 1)  //if 1 or more hours passed
            $strdiff = "" . intval($timediff[0]) . " h";    //convert integer passed hour value into string type.
        else if($timediff[1] >= 1)  //if 1 or more minutes passed
            $strdiff = "" . intval($timediff[1]) . " m";    //convert integer passed minute value into string type.
        else
            $strdiff = "Now";

        // insert friend username,notification count,last message and the passed time since last message into the $requests array.
        array_push($requests, array($row["friend"], $row["counts"],$row["lastmsg"], $strdiff));
    }
    
    //return $requests array in json type.
    echo json_encode($requests);

?>
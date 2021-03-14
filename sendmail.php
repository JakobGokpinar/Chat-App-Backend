<?php

    $adminmails = array("ahmettabar2003@gmail.com", "imparatorahmett@gmail.com"); //email addresses where the email will be sent.
    $to = implode(",", $adminmails);
    $senderemail = $_POST["email"]; //Get sender email from form
    $subject = $_POST["subject"]; //Get mail subject from form
    $message = "sender: $senderemail" . "\n" . $_POST["message"]; //Create the message content
    $headers = "From: ahmettabar2003@gmail.com" . "\r\n" .
    "CC: ahmettabar2003@gmail.com";

    $result = mail($to,$subject,$message,$headers);
    echo $result;
?>
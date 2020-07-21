<?php
$adminmails = array("ahmettabar2003@gmail.com", "imparatorahmett@gmail.com");
$to = implode(",", $adminmails);
$senderemail = $_POST["email"];
$subject = $_POST["subject"];
$message = "sender: $senderemail" . "\n" . $_POST["message"];
$headers = "From: ahmettabar2003@gmail.com" . "\r\n" .
"CC: ahmettabar2003@gmail.com";

mail($to,$subject,$message,$headers);
?>
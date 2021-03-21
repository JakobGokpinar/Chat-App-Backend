<?php
require 'sendgrid/sendgrid-php.php';
require '@sendgrid/mail';
   /* require 'vendor/autoload.php';
    

    $senderemail = $_POST["email"]; //Get sender's email from frontend.
    $name = explode("@",$senderemail)[0];
    $subject = $_POST["subject"]; 
    $message = $_POST["message"];

    $email = new \SendGrid\Mail\Mail();
    $API_KEY = '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'; 
    $email->setFrom("ahmettabar2003@gmail.com", $name);
    $email->setSubject("(Contact Us) ".$subject);
    $email->addTo("ahmettabar2003@gmail.com", "GokSoft Technologies");
    $email->addContent("text/plain", "From:  $senderemail \n\n$message");

    $sendgrid = new \SendGrid($API_KEY);
    try {
        $response = $sendgrid->send($email);
        print $response->statusCode() . "\n";
        print_r($response->headers());
        print $response->body() . "\n";
        echo "mail sent";
    } catch (Exception $e) {
        echo 'Caught exception: '. $e->getMessage() ."\n";
    }*/


    ini_set("SMTP", "smtp.sendgrid.net");
    ini_set("sendmail_from", "ahmettabar2003@gmail.com");
    ini_set("Port", "25");
    ini_set("Username", "apikey");
    ini_set("Password", "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");

$message = "The mail message was sent with the following mail setting:\r\nSMTP = aspmx.l.google.com\r\nsmtp_port = 25\r\nsendmail_from = YourMail@address.com";

$headers = "From: ahmettabar2003@gmail.com";

try {
    $res = mail("ahmettabar2003@gmail.com", "Testing", $message, $headers);
    if($res){
        echo "mailsent";
    }
    else{
        echo "not sent";
    }
echo "Check your email now....&lt;BR/>";
} catch (Exception $e) {
    echo 'Caught exception: '. $e->getMessage() ."\n";
}


?>
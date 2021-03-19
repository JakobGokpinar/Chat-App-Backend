<?php
    require 'vendor/autoload.php';
    require 'sendgrid/sendgrid-php.php';

    /*$senderemail = $_POST["email"]; //Get sender's email from frontend.
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
?>
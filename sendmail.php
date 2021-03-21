<?php
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

    $senderemail = $_POST["email"]; //Get sender's email from frontend.
    $name = explode("@",$senderemail)[0];
    $subject = $_POST["subject"]; 
    $message = $_POST["message"];

    $subject = "(Contact Us) $subject";
    $body = "From:  $senderemail" . "\n\n" . $message;

    $headers = array(
        'Authorization: Bearer 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',
        'Content-Type: application/json'
    );

    $data = array(
        "personalizations" => array(
            array(
                "to" => array(
                    array(
                        "email" => "ahmettabar2003@gmail.com",
                        "name" => $name
                    )
                )
            )
        ),
        "from" => array(
            "email" => "ahmettabar2003@gmail.com",
            "name" => $name
        ),
        "subject" => $subject,
        "content" => array(
            array(
                "type" => "text/html",
                "value" => $body
            )
        )
    );

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, "https://api.sendgrid.com/v3/mail/send");
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    $response = curl_exec($ch);
    curl_close($ch);

    echo "cevap";
    echo $response;
  


?>
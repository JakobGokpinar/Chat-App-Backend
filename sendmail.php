<?php
    require 'checklog.php';

    $senderemail = $_POST["email"]; //Get sender's email from frontend.
    $name = explode("@",$senderemail)[0];
    $subject = $_POST["subject"]; 
    $message = $_POST["message"];

    $subject = "(Contact Us) $subject";
    $body = "From:  $senderemail <br><br> $message";

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

    try{
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, "https://api.sendgrid.com/v3/mail/send");
        curl_setopt($ch, CURLOPT_POST, 1);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $response = curl_exec($ch);
        curl_close($ch);
        echo "Your message has been successfully. Thanks For Your Feedback!";
    } catch(Exception $e){
        echo "Sorry, an error occured! Your mail could not be sent.";
        echo "Error: " . $e->getMessage();
    }

?>
<?php
    
    /*require("sendgrid/sendgrid-php.php");

    $name = "Chat App Mail";
    $senderemail = $_POST["email"];
    $subject = $_POST["subject"];
    $message = $_POST["message"];

    $email = new \SendGrid\Mail\Mail(); 
    $email->setFrom($senderemail,$name);
    $email->setSubject($subject);
    $email->addTo($senderemail);
    $email->addContent("text/plain", $message);

    $sendgrid = new \SendGrid("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");
    try {
        $response = $sendgrid->send($email);
        print $response->statusCode() . "\n";
        print_r($response->headers());
        print $response->body() . "\n";
    } catch (Exception $e) {
        echo 'Caught exception: '. $e->getMessage() ."\n";
    }*/


    /*use PHPMailer\PHPMailer\PHPMailer;

    $name = "tolga";
    $email = $_POST["email"];
    $subject = $_POST["subject"];
    $body = $_POST["message"];
    
    require_once "PHPMailer/PHPMailer.php";
    require_once "PHPMailer/SMTP.php";
    require_once "PHPMailer/Exception.php";

    $mail = new PHPMailer();

    //$mail->SMTPDebug = SMTP::DEBUG_SERVER; 
    $mail->isSMTP();
    $mail->Host = "smtp.sendgrid.net";
    $mail->SMTPAuth = true;
    $mail->Username = "apikey";
    $mail->Password = "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";
    $mail->Port = 465;
    $mail->SMPTSecure = "ssl";

    $mail->isHTML(false);
    $mail->setFrom($email, $name);
    $mail->addAddress("ahmettabar2003@gmail.com");
    $mail->Subject = ("$email ($subject");
    $mail->Body = $body;

    if($mail->send()){
        $status = "success";
        $response = "Email is sent!";
    }
    else{
        $status = "failed";
        $response = "something went wrong : <br>" . $mail->ErrorInfo;
    }
    
    exit(json_encode(array("status" => $status, "response" => $response)));*/



    /*$adminmails = array("ahmettabar2003@gmail.com", "imparatorahmett@gmail.com"); //email addresses where the email will be sent.
    $to = implode(",", $adminmails);
    $senderemail = $_POST["email"]; //Get sender email from form
    $subject = $_POST["subject"]; //Get mail subject from form
    $message = "sender: $senderemail" . "\n" . $_POST["message"]; //Create the message content
    $headers = "From: ahmettabar2003@gmail.com" . "\r\n" .
    "CC: ahmettabar2003@gmail.com";

    // Please specify your Mail Server - Example: mail.example.com.
    ini_set("SMTP","smtp.sendgrid.com");

// Please specify an SMTP Number 25 and 8889 are valid SMTP Ports.
    ini_set("smtp_port","25");

// Please specify the return address to use
    ini_set('sendmail_from', $senderemail);

    $result = mail($to,$subject,$message,$headers);
    if($result){
        echo "sentt";
    }
    else{
        echo "fail";
    }*/

    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;

    require_once __DIR__ . '/vendor/phpmailer/src/Exception.php';
    require_once __DIR__ . '/vendor/phpmailer/src/PHPMailer.php';
    require_once __DIR__ . '/vendor/phpmailer/src/SMTP.php';

    $name = "Chat App Mail";
    $senderemail = $_POST["email"];
    $name = explode("@",$senderemail)[0];
    $subject = $_POST["subject"];
    $message = $_POST["message"];

    // passing true in constructor enables exceptions in PHPMailer
    $mail = new PHPMailer(true);

    try {
        // Server settings
        $mail->SMTPDebug = SMTP::DEBUG_SERVER; // for detailed debug output
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
        $mail->Port = 587;

        $mail->Username = 'ahmettabar2003@gmail.com'; // YOUR gmail email
        $mail->Password = 'b2003tgdg'; // YOUR gmail password

        // Sender and recipient settings
        $mail->setFrom('ahmettabar2003@gmail.com', $name);
        $mail->addAddress('ahmettabar2003@gmail.com', 'GokSoft Technologies');
        //$mail->addReplyTo('ahmettabar2003@gmail.com', 'Replier Name'); // to set the reply to

        // Setting the email content
        $mail->IsHTML(true);
        $mail->Subject = "(Contact Us) ".$subject;
        $mail->Body = "From:  $senderemail <br> <br> $message";

        
        if($mail->send()){
            echo "mail sent";
        } else{
            echo "not sent";
        }
    } catch (Exception $e) {
        echo "Error in sending email. Mailer Error: {$mail->ErrorInfo}";
    }
?>
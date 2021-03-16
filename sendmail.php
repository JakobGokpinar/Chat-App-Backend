<?php
    //PHPMailer is a library to send emails via Php. 
    //Use needed classes from PHPMailer.
    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;

    require_once __DIR__ . '/vendor/phpmailer/src/Exception.php';
    require_once __DIR__ . '/vendor/phpmailer/src/PHPMailer.php';
    require_once __DIR__ . '/vendor/phpmailer/src/SMTP.php';

    $senderemail = $_POST["email"]; //Get sender's email from frontend.
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


        // Sender and recipient settings
        $mail->setFrom('ahmettabar2003@gmail.com', $name);
        $mail->addAddress('ahmettabar2003@gmail.com', 'GokSoft Technologies');

        // Setting the email content
        $mail->IsHTML(true);
        $mail->Subject = "(Contact Us) ".$subject;
        $mail->Body = "From:  $senderemail <br> <br> $message";
        
        if($mail->send()){
            echo "mail sent";
        } else{
            echo "mail not sent";
        }
    } catch (Exception $e) {
        echo "Error in sending email. Mailer Error: {$mail->ErrorInfo}";
    }
?>
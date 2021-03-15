<?php
    
    require("sendgrid/sendgrid-php.php");

    $email = new \SendGrid\Mail\Mail(); 
$email->setFrom("ahmettabar2003@gmail.com", "Example User");
$email->setSubject("Sending with SendGrid is Fun");
$email->addTo("ahmettabar2003@gmail.com", "Example User");
$email->addContent("text/plain", "bu bir test mesajı");

$sendgrid = new \SendGrid("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");
try {
    $response = $sendgrid->send($email);
    print $response->statusCode() . "\n";
    print_r($response->headers());
    print $response->body() . "\n";
} catch (Exception $e) {
    echo 'Caught exception: '. $e->getMessage() ."\n";
}
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

    $result = mail($to,$subject,$message,$headers);
    echo $result;*/
?>
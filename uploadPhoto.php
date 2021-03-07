<?php
    require 'connection.php';
    require 'checklog.php';
    require 'vendor/autoload.php';

    use Aws\S3\S3Client;

    use Aws\Exception\AwsException;

    $s3Client = new S3Client([
        'version'     => 'latest',
        'region'      => 'eu-central-1',
        'credentials' => [
            'key'    => 'AKIAU4LAKYYRWW6SJQOM',
            'secret' => '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',
        ],
    ]);

    
    function encode_file_path($str){
        $badchars = array(['/', '!'], ['*', '.']);
        
        for($i = 0; $i < count($badchars); $i++)
            $str = str_replace($badchars[$i][0], $badchars[$i][1], $str);

        return $str;
    }
    $arr = explode(".", $_FILES["photo"]["name"]);
    if(!in_array( $arr[count($arr)-1], array("png", "jpg", "jpeg") )){
        echo "not image file";
        exit(0);
    }
    if ($_FILES["photo"]["size"] > 500000) {
        echo "too big file";
        exit(0);
    }

    $gillbates = "users\\" .  encode_file_path($username);

    if (!file_exists($gillbates)) {
        mkdir($gillbates, 0777, true); 
    } 

    move_uploaded_file($_FILES["photo"]["tmp_name"],  $gillbates . "\\icon.png");
    

    echo "pp changed";
?>

<?php
	
	require 'connection.php';
    require 'checklog.php';
    require 'vendor/autoload.php';
	
	use Aws\S3\S3Client;
	use Aws\S3\Exception\S3Exception;

	// AWS Info
	$bucketName = 'cloud-cube';
	$IAM_KEY = 'AKIA37SVVXBHQAHBPQXF';
	$IAM_SECRET = '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';

	// Connect to AWS
	try {
		// You may need to change the region. It will say in the URL when the bucket is open
		// and on creation.
		$s3 = S3Client::factory(
			array(
				'credentials' => array(
					'key' => $IAM_KEY,
					'secret' => $IAM_SECRET
				),
				'version' => 'latest',
				'region'  => 'us-east-1'
			)
		);
	} catch (Exception $e) {
		// We use a die, so if this fails. It stops here. Typically this is a REST call so this would
		// return a json object.
		die("Error: " . $e->getMessage());
	}

    
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

    $gillbates = "users/" .  encode_file_path($username);


	// For this, I would generate a unqiue random string for the key name. But you can do whatever.
	$keyName = "icon.png";
	$pathInS3 = 'https://cloud-cube.s3.amazonaws.com/zvtagezl6h5s/' . $bucketName . '/' . $keyName;

	// Add it to S3
	try {
		// Uploaded:
		$file = $_FILES["photo"]['tmp_name'];

		$s3->putObject(
			array(
				'Bucket'=> $bucketName,
				'Key' =>  $keyName,
				'Body' => "ads",
				'SourceFile' => $file,
				'StorageClass' => 'REDUCED_REDUNDANCY'
			)
		);

	} catch (S3Exception $e) {
		die('Error:' . $e->getMessage());
	} catch (Exception $e) {
		die('Error:' . $e->getMessage());
	}


	echo "pp changed";

	// Now that you have it working, I recommend adding some checks on the files.
	// Example: Max size, allowed file types, etc.
?>
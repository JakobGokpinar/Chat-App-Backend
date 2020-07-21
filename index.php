<?php
include("vendor\\adodb\\adodb.inc.php");
//echo "hi man";

$cleardb_url      = parse_url(getenv("mysql://bfca2adbd98d3d:ebebb0b8@us-cdbr-east-02.cleardb.com/heroku_77553a4fbd53445?reconnect=true"));
$cleardb_server   = $cleardb_url["host"];
$cleardb_username = $cleardb_url["user"];
$cleardb_password = $cleardb_url["pass"];
$cleardb_db       = substr($cleardb_url["path"],1);

$db = NewADOConnection('mysqli');
$db->Connect(
	$cleardb_server,
	$cleardb_username,
	$cleardb_password,
	$cleardb_db);

// Ensure fields are (only) indexed by column name
$ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;

// Use UTF-8
$db->EXECUTE("set names 'utf8'"); 

?>
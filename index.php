<?php

// Grabs the URI and breaks it apart in case we have querystring stuff
$request_uri = explode('?', $_SERVER['REQUEST_URI'], 2);

if(isset($routes[$request_uri[0]])) {
  require '$routes[$request_uri[0]]';
} else {
  header('HTTP/1.0 404 Not Found');
  require '404.php';
}

?>
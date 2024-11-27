<?php

require "connect.php";
session_start();

if (!isset($_SESSION['iduser'])) {
    header("Location: login.php");
    exit();
}


?>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    Halo
</body>
</html>
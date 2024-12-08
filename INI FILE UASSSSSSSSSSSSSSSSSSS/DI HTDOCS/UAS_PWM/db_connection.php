<?php
header('Content-Type: application/json');

$hostname = '127.0.0.1';
$username = 'root';
$password = '';
$db = 'db_elektronik';

$conn = new mysqli($hostname, $username, $password, $db);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}
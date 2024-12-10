<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

// Ambil data dari request
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['user_id']) && isset($data['product_id'])) {
    $user_id = intval($data['user_id']);
    $product_id = $data['product_id'];

    $query = "INSERT INTO riwayat_belanja (user_id, product_id) VALUES ($user_id, '$product_id')";

    if (mysqli_query($connect, $query)) {
        echo json_encode(array("message" => "Purchase history saved successfully"));
    } else {
        echo json_encode(array("message" => "Failed to save purchase history"));
    }
} else {
    echo json_encode(array("message" => "Invalid input"));
}

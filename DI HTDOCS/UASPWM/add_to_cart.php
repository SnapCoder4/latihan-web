<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$user_id = $_POST['user_id'] ?? null;
$idproduct = $_POST['idproduct'] ?? null;
$quantity = $_POST['quantity'] ?? 1;

if ($user_id && $idproduct) {
    $check_query = "SELECT * FROM cart WHERE user_id = ? AND idproduct = ?";
    $stmt = $connect->prepare($check_query);
    $stmt->bind_param("is", $user_id, $idproduct);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $update_query = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND idproduct = ?";
        $update_stmt = $connect->prepare($update_query);
        $update_stmt->bind_param("iis", $quantity, $user_id, $idproduct);
        $update_stmt->execute();
        echo json_encode(["message" => "Quantity updated"]);
    } else {
        $insert_query = "INSERT INTO cart (user_id, idproduct, quantity) VALUES (?, ?, ?)";
        $insert_stmt = $connect->prepare($insert_query);
        $insert_stmt->bind_param("isi", $user_id, $idproduct, $quantity);
        $insert_stmt->execute();
        echo json_encode(["message" => "Product added to cart"]);
    }
} else {
    echo json_encode(["message" => "Invalid input"]);
}
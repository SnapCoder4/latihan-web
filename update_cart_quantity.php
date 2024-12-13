<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$user_id = $_POST['user_id'] ?? null;
$idproduct = $_POST['idproduct'] ?? null;
$quantity = $_POST['quantity'] ?? null;

if ($user_id && $idproduct && isset($quantity)) {
    if ($quantity == 0) {
        $delete_query = "DELETE FROM cart WHERE user_id = ? AND idproduct = ?";
        $stmt = $connect->prepare($delete_query);
        $stmt->bind_param("is", $user_id, $idproduct);
        $stmt->execute();
        echo json_encode(["message" => "Item removed from cart"]);
    } else {
        $update_query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND idproduct = ?";
        $stmt = $connect->prepare($update_query);
        $stmt->bind_param("iis", $quantity, $user_id, $idproduct);
        $stmt->execute();
        echo json_encode(["message" => "Quantity updated"]);
    }
} else {
    echo json_encode(["message" => "Invalid input"]);
}

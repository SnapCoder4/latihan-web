<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$user_id = $_GET['user_id'] ?? null;

if ($user_id) {
    $query = "SELECT c.idproduct, p.product, p.image, p.price, c.quantity 
              FROM cart c
              INNER JOIN namaproduct p ON c.idproduct = p.idproduct
              WHERE c.user_id = ?";
    $stmt = $connect->prepare($query);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $cart = [];
    while ($row = $result->fetch_assoc()) {
        $cart[] = $row;
    }

    echo json_encode($cart);
} else {
    echo json_encode(["message" => "User ID not provided"]);
}

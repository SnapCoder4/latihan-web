<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$user_id = $_POST['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(["message" => "User ID not provided"]);
    exit;
}

try {
    $query = "SELECT cart.idproduct, cart.quantity, namaproduct.price 
              FROM cart 
              JOIN namaproduct ON cart.idproduct = namaproduct.idproduct 
              WHERE cart.user_id = ?";
    $stmt = $connect->prepare($query);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 0) {
        echo json_encode(["message" => "No items in cart"]);
        exit;
    }

    $total_price = 0;
    $connect->begin_transaction();

    while ($row = $result->fetch_assoc()) {
        $total_price += $row['price'] * $row['quantity'];

        // Pastikan idjual auto_increment untuk menghindari duplikasi
        $insert_query = "INSERT INTO jual (tgljual, idproduct, price, quantity) 
                         VALUES (NOW(), ?, ?, ?)";
        $insert_stmt = $connect->prepare($insert_query);
        if (!$insert_stmt) {
            $connect->rollback();
            echo json_encode(["message" => "Insert failed: " . $connect->error]);
            exit;
        }

        $insert_stmt->bind_param("sii", $row['idproduct'], $row['price'], $row['quantity']);
        $insert_stmt->execute();
    }

    $delete_query = "DELETE FROM cart WHERE user_id = ?";
    $delete_stmt = $connect->prepare($delete_query);
    $delete_stmt->bind_param("i", $user_id);
    $delete_stmt->execute();

    $connect->commit();
    echo json_encode(["message" => "Checkout successful", "total_price" => $total_price]);
} catch (Exception $e) {
    $connect->rollback();
    echo json_encode(["message" => "Error: " . $e->getMessage()]);
}

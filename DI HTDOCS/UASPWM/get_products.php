<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$response = array();

try {
    // Query untuk mengambil data produk
    $query = "SELECT * FROM namaproduct"; // Pastikan nama tabel sesuai dengan database Anda
    $result = mysqli_query($connect, $query);

    if (!$result) {
        throw new Exception("Query error: " . mysqli_error($connect));
    }

    $products = array();

    // Ambil hasil query dalam bentuk array
    while ($row = mysqli_fetch_assoc($result)) {
        $products[] = $row;
    }

    // Kirimkan data produk sebagai JSON
    echo json_encode($products);
} catch (Exception $e) {
    // Tangani error dengan respons JSON
    $response['value'] = 0;
    $response['message'] = $e->getMessage();
    echo json_encode($response);
}
<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

// Pastikan user_id diterima
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

if ($user_id > 0) {
    // Ambil data dari tabel jual dan namaproduct
    $query = "SELECT j.tgljual, p.product, j.price, j.quantity, p.image 
              FROM jual j
              INNER JOIN namaproduct p ON j.idproduct = p.idproduct
              ORDER BY j.tgljual DESC";

    $result = mysqli_query($connect, $query);

    if ($result) {
        $riwayat = array();

        // Iterasi data dari database
        while ($row = mysqli_fetch_assoc($result)) {
            $riwayat[] = $row;
        }

        // Kirim data dalam format JSON
        echo json_encode($riwayat);
    } else {
        echo json_encode(array("message" => "Error fetching purchase history"));
    }
} else {
    echo json_encode(array("message" => "Invalid user ID"));
}

<?php
// Header untuk mengatur akses dan tipe konten
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php'; // Koneksi ke database

// Pastikan `user_id` diterima dari permintaan GET
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

if ($user_id > 0) {
    try {
        // Query untuk mengambil data riwayat belanja berdasarkan `user_id`
        $query = "SELECT j.tgljual, p.product, j.price, j.quantity, p.image 
                  FROM jual j
                  INNER JOIN namaproduct p ON j.idproduct = p.idproduct
                  WHERE j.idjual IS NOT NULL 
                  ORDER BY j.tgljual DESC";

        $stmt = $connect->prepare($query);

        if (!$stmt) {
            echo json_encode(["message" => "Database preparation failed"]);
            exit;
        }

        $stmt->execute();
        $result = $stmt->get_result();

        // Buat array untuk menyimpan hasil query
        $riwayat = [];
        while ($row = $result->fetch_assoc()) {
            $riwayat[] = $row;
        }

        // Kirim hasil dalam format JSON
        echo json_encode($riwayat);
    } catch (Exception $e) {
        // Jika terjadi kesalahan
        echo json_encode(["message" => "Error occurred: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["message" => "Invalid user ID"]);
}

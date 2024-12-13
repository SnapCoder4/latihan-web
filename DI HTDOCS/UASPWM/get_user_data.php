<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $user_id = $_GET['user_id'] ?? null;

    if (!$user_id) {
        $response['value'] = 0;
        $response['message'] = "User ID tidak ditemukan.";
        echo json_encode($response);
        exit();
    }

    $query = "SELECT nama, email, foto FROM users WHERE id = ?";
    $stmt = $connect->prepare($query);

    if ($stmt) {
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $response['value'] = 1;
            $response['message'] = "Data ditemukan.";
            $response['nama'] = $row['nama'] ?? "Nama Tidak Ada";
            $response['email'] = $row['email'] ?? "Email Tidak Ada";

            // Pastikan URL foto benar, gunakan gambar default jika kosong
            $fotoPath = $row['foto'] ?? "";
            $response['foto'] = !empty($fotoPath)
                ? "http://192.168.0.149/UASPWM/" . $fotoPath
                : "http://192.168.0.149/UASPWM/images/user.png";
        } else {
            $response['value'] = 0;
            $response['message'] = "Pengguna tidak ditemukan.";
        }

        $stmt->close();
    } else {
        $response['value'] = 0;
        $response['message'] = "Kesalahan pada server.";
    }

    echo json_encode($response);
} else {
    $response['value'] = 0;
    $response['message'] = "Metode request tidak valid.";
    echo json_encode($response);
}
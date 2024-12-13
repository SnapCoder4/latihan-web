<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array(); // Inisialisasi array untuk respon

    // Mengambil data dari POST request
    $verification_code = $_POST['verification_code'] ?? null;
    $email = $_POST['email'];

    // Validasi kode verifikasi dan email
    if (!empty($verification_code) && !empty($email)) {
        $query = "SELECT * FROM users WHERE email = ? AND verification_code = ?";
        $stmt = $connect->prepare($query);
        $stmt->bind_param("ss", $email, $verification_code);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 1) {
            // Kode verifikasi valid
            $response['value'] = 1;
            $response['message'] = 'Kode verifikasi berhasil.';
        } else {
            // Kode verifikasi salah
            $response['value'] = 0;
            $response['message'] = 'Kode verifikasi salah.';
        }

        $stmt->close(); // Menutup statement
    } else {
        // Jika ada field yang kosong
        $response['value'] = 0;
        $response['message'] = 'Semua field wajib diisi.';
    }

    // Mengembalikan respons dalam format JSON
    echo json_encode($response);
} else {
    // Jika request method bukan POST
    $response['value'] = 0;
    $response['message'] = 'Permintaan tidak valid.';
    echo json_encode($response);
}
?>
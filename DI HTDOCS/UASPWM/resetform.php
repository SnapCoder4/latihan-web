<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
require 'db_connection.php'; // Koneksi ke database

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $response = array(); // Inisialisasi array untuk respon

    // Mengambil data dari POST request
    $email = $_POST['email'] ?? null;
    $new_password = $_POST['new_password'] ?? null;

    // Validasi input
    if (!empty($email) && !empty($new_password)) {
        $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

        // Menggunakan prepared statement untuk mengupdate password
        $query = "UPDATE users SET password = ? WHERE email = ?";
        $stmt = $connect->prepare($query);
        $stmt->bind_param("ss", $hashed_password, $email);

        if ($stmt->execute()) {
            $response['value'] = 1;
            $response['message'] = 'Password berhasil diubah.';
        } else {
            $response['value'] = 0;
            $response['message'] = 'Gagal mengubah password.';
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
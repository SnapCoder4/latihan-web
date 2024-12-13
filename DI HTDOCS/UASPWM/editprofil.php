<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header("Content-Type: application/json; charset=UTF-8");

// Menghubungkan ke database
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Inisialisasi array untuk respon

    // Mengambil data dari POST request
    $id = $_POST['id'] ?? null;
    $nama = $_POST['nama'] ?? null;
    $alamat = $_POST['alamat'] ?? null;
    $telepon = $_POST['telepon'] ?? null;

    // Cek apakah semua field terisi dan id ada
    if (!empty($id) && !empty($nama) && !empty($alamat) && !empty($telepon)) {

        // Update query untuk mengubah data profil
        $stmt = $connect->prepare("UPDATE users SET nama = ?, alamat = ?, telepon = ? WHERE id = ?");
        // Bind parameter dengan tipe data yang sesuai
        $stmt->bind_param("ssss", $nama, $alamat, $telepon, $id);

        // Menjalankan query
        if ($stmt->execute()) {
            // Jika penyimpanan berhasil
            $response['value'] = 1;
            $response['message'] = 'Profile successfully updated.';
        } else {
            // Jika terjadi kesalahan saat menyimpan
            $response['value'] = 0;
            $response['message'] = 'Error updating profile: ' . $stmt->error;
        }

        $stmt->close(); // Menutup statement
    } else {
        // Jika ada field yang kosong atau id tidak ada
        $response['value'] = 0;
        $response['message'] = 'All fields are required.';
    }

    // Mengembalikan respons dalam format JSON
    echo json_encode($response);
} else {
    // Jika request method bukan POST
    $response['value'] = 0;
    $response['message'] = 'Invalid request method.';
    echo json_encode($response);
}
?>
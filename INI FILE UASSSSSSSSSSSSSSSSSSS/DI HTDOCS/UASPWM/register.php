<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Menghubungkan ke database
require 'connect.php';

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Inisialisasi array untuk respon

    // Mengambil data dari POST request
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;
    $nama = $_POST['nama'] ?? null;
    $alamat = $_POST['alamat'] ?? null;
    $telepon = $_POST['telepon'] ?? null;

    // Cek apakah semua field terisi
    if (!empty($email) && !empty($password) && !empty($nama) && !empty($alamat) && !empty($telepon)) {
        // Hashing password sebelum menyimpan
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        // Membuat ID dengan awalan 'I' dan 4 angka acak
        $id = 'I' . str_pad(rand(0, 9999), 4, '0', STR_PAD_LEFT); // Menghasilkan ID seperti I1234

        // Menggunakan prepared statement untuk menghindari SQL Injection
        // Menambahkan field "createdDate" dengan nilai default dari fungsi NOW() MySQL
        $stmt = $connect->prepare("INSERT INTO users (id, email, password, nama, alamat, telepon, createdDate) VALUES (?, ?, ?, ?, ?, ?, NOW())");
        $stmt->bind_param("ssssss", $id, $email, $hashed_password, $nama, $alamat, $telepon); // 's' = string

        // Menjalankan query
        if ($stmt->execute()) {
            // Jika penyimpanan berhasil
            $response['value'] = 1;
            $response['message'] = 'Registrasi berhasil diproses';
            $response['id'] = $id;
        } else {
            // Jika terjadi kesalahan saat menyimpan
            $response['value'] = 0;
            $response['message'] = 'Gagal menyimpan data: ' . $stmt->error;
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
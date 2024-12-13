<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require "db_connection.php";

$response = []; // Inisialisasi array untuk menyimpan respons

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Ambil data dari request
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;
    $nama = $_POST['nama'] ?? null;
    $alamat = $_POST['alamat'] ?? null;
    $telepon = $_POST['telepon'] ?? null;

    // Validasi input
    if (!$email || !$password || !$nama || !$alamat || !$telepon) {
        $response['value'] = 0;
        $response['message'] = "Semua field wajib diisi.";
        echo json_encode($response);
        exit();
    }

    // Hash password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    $photoUrl = ""; // Default foto kosong

    // Proses unggah foto
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $allowedTypes = ['image/jpeg', 'image/png', 'image/jpg'];
        $fileType = mime_content_type($_FILES['photo']['tmp_name']);

        if (!in_array($fileType, $allowedTypes)) {
            $response['value'] = 0;
            $response['message'] = "Tipe file tidak diizinkan. Gunakan file gambar (JPEG/PNG).";
            echo json_encode($response);
            exit();
        }

        $photoName = uniqid() . '_' . basename($_FILES['photo']['name']);
        $uploadDirectory = 'uploads/';

        // Buat folder jika belum ada
        if (!is_dir($uploadDirectory)) {
            mkdir($uploadDirectory, 0777, true);
        }

        $photoPath = $uploadDirectory . $photoName;

        // Pindahkan file yang diunggah
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $photoPath)) {
            $photoUrl = $photoPath; // Simpan path foto
        } else {
            $response['value'] = 0;
            $response['message'] = "Gagal mengunggah foto.";
            echo json_encode($response);
            exit();
        }
    }

    // Query untuk memasukkan data pengguna ke database
    $query = "INSERT INTO users (email, password, nama, alamat, telepon, foto) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $connect->prepare($query);

    if ($stmt) {
        $stmt->bind_param("ssssss", $email, $hashedPassword, $nama, $alamat, $telepon, $photoUrl);

        if ($stmt->execute()) {
            $response['value'] = 1;
            $response['message'] = "Registrasi berhasil.";
            $response['user_id'] = $connect->insert_id; // Ambil user_id terakhir
            $response['photo_url'] = "http://192.168.1.2/lat_login/" . $photoUrl; // URL lengkap untuk foto
        } else {
            $response['value'] = 0;
            $response['message'] = "Gagal menyimpan data. Error: " . $stmt->error;
        }

        $stmt->close();
    } else {
        $response['value'] = 0;
        $response['message'] = "Kesalahan pada server. Error: " . $connect->error;
    }

    echo json_encode($response);
} else {
    // Jika metode request bukan POST
    $response['value'] = 0;
    $response['message'] = "Metode request tidak valid.";
    echo json_encode($response);
}
?>

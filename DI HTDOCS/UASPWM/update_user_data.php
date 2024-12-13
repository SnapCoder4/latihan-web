<?php
// Mengatur CORS dan format respons JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require "db_connection.php";

$response = []; // Inisialisasi array untuk respons

if ($_SERVER['REQUEST_METHOD'] === "POST") {
    // Mengambil data dari request
    $user_id = $_POST['user_id'] ?? null;
    $name = $_POST['name'] ?? null;
    $email = $_POST['email'] ?? null;

    // Validasi input
    if (empty($user_id) || empty($name) || empty($email)) {
        $response['value'] = 0;
        $response['message'] = "Semua field wajib diisi.";
        echo json_encode($response);
        exit();
    }

    $photo_url = null; // Variabel untuk menyimpan URL foto jika ada

    // Proses unggah foto
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] === UPLOAD_ERR_OK) {
        $photoName = uniqid() . '_' . basename($_FILES['photo']['name']);
        $uploadDirectory = 'uploads/';

        // Pastikan folder 'uploads' ada, jika tidak buat foldernya
        if (!is_dir($uploadDirectory)) {
            mkdir($uploadDirectory, 0777, true);
        }

        $photoPath = $uploadDirectory . $photoName;

        // Pindahkan file yang diunggah ke folder tujuan
        if (move_uploaded_file($_FILES['photo']['tmp_name'], $photoPath)) {
            $photo_url = $photoPath;
        } else {
            $response['value'] = 0;
            $response['message'] = "Gagal mengunggah foto.";
            echo json_encode($response);
            exit();
        }
    }

    // Query untuk memperbarui data pengguna
    $updateQuery = "UPDATE users SET nama = ?, email = ?" . ($photo_url ? ", foto = ?" : "") . " WHERE id = ?";
    $stmt = $connect->prepare($updateQuery);

    // Bind parameter sesuai dengan kondisi (dengan atau tanpa foto)
    if ($photo_url) {
        $stmt->bind_param("sssi", $name, $email, $photo_url, $user_id);
    } else {
        $stmt->bind_param("ssi", $name, $email, $user_id);
    }

    // Eksekusi query dan kirimkan respons
    if ($stmt->execute()) {
        $response['value'] = 1;
        $response['message'] = "Profil berhasil diperbarui.";
        $response['photo_url'] = "http://192.168.1.2/lat_login/" . $photo_url; // URL lengkap foto
    } else {
        $response['value'] = 0;
        $response['message'] = "Gagal memperbarui profil.";
    }

    echo json_encode($response);
} else {
    // Jika metode request bukan POST
    $response['value'] = 0;
    $response['message'] = "Metode request tidak valid.";
    echo json_encode($response);
}
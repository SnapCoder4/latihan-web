<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Menghubungkan ke database
require 'db_connection.php';

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Inisialisasi array untuk respon

    // Mengambil data dari POST request
    $nama = $_POST['nama'] ?? null;
    $alamat = $_POST['alamat'] ?? null;
    $telepon = $_POST['telepon'] ?? null;
    $id = $_POST['id'] ?? null;

    // Cek apakah semua field terisi
    if (!empty($nama) && !empty($alamat) && !empty($telepon)) {
        // Mengatur default path foto
        $photoUrl = "";

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
            $uploadDirectory = 'images/';

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

        // Update data pengguna
        $stmt = $connect->prepare("UPDATE users SET nama = ?, alamat = ?, telepon = ?, foto = ? WHERE id = ?");
        $stmt->bind_param("ssssi", $nama, $alamat, $telepon, $photoUrl, $id);

        // Menjalankan query
        if ($stmt->execute()) {
            // Jika update berhasil
            $response['value'] = 1;
            $response['message'] = 'Profil berhasil diperbarui';
            $response['photo_url'] = "http://192.168.0.149/images/" . $photoUrl;
        } else {
            // Jika terjadi kesalahan saat update
            $response['value'] = 0;
            $response['message'] = 'Gagal memperbarui data: ' . $stmt->error;
        }

        $stmt->close();
    } else {
        // Jika ada data yang tidak lengkap
        $response['value'] = 0;
        $response['message'] = 'Semua field wajib diisi.';
    }

    // Mengembalikan response dalam format JSON
    echo json_encode($response);
}
?>
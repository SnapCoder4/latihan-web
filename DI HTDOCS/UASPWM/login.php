<?php
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Menghubungkan ke database
require "db_connection.php";

// Memeriksa metode request
if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Inisialisasi array untuk menyimpan respon

    // Mengambil email dan password dari POST request
    $email = $_POST['email'];
    $password = $_POST['password']; // Password dari input form

    // Membuat query untuk mengambil data pengguna berdasarkan email
    $cek = "SELECT * FROM users WHERE email='$email'";

    // Menjalankan query
    $result = mysqli_query($connect, $cek);

    // Periksa apakah query berhasil
    if (!$result) {
        echo json_encode(array(
            "value" => 0,
            "message" => "Kesalahan pada query database: " . mysqli_error($connect)
        ));
        exit();
    }

    // Mengecek apakah hasil query valid
    if (mysqli_num_rows($result) > 0) {
        // Mengambil data pengguna dari database
        $row = mysqli_fetch_assoc($result);

        // Memverifikasi password dengan hash yang tersimpan di database
        if (password_verify($password, $row['password'])) {
            // Jika password cocok, login berhasil
            $response['value'] = 1;
            $response['message'] = 'Login Berhasil';
            $response['user_id'] = $row['id'];  // Kirimkan ID pengguna
        } else {
            // Jika password tidak cocok
            $response['value'] = 0;
            $response['message'] = 'Login gagal. Password salah.';
        }
    } else {
        // Jika email tidak ditemukan di database
        $response['value'] = 0;
        $response['message'] = 'Login gagal. Email tidak ditemukan.';
    }

    // Mengembalikan respon dalam format JSON
    echo json_encode($response);
} else {
    // Jika request method bukan POST
    $response['value'] = 0;
    $response['message'] = "Permintaan tidak valid.";
    echo json_encode($response);
}
?>
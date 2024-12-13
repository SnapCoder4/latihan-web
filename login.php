<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Menghubungkan ke database
require_once "db_connection.php";

if ($_SERVER['REQUEST_METHOD'] === "POST") {
    $response = array(); // Inisialisasi array untuk menyimpan respon

    // Mengambil email dan password dari POST request
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;

    // Validasi input email dan password
    if (empty($email) || empty($password)) {
        $response['value'] = 0;
        $response['message'] = "Email dan password wajib diisi.";
        echo json_encode($response);
        exit();
    }

    // Membuat query untuk mengambil data pengguna berdasarkan email
    $cek = "SELECT * FROM users WHERE email = ?";
    $stmt = $connect->prepare($cek);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    // Mengecek apakah hasil query valid
    if ($result && $result->num_rows > 0) {
        // Mengambil data pengguna dari database
        $row = $result->fetch_assoc();

        // Membandingkan password yang dimasukkan dengan hash password yang ada di database
        if (password_verify($password, $row['password'])) {
            // Jika password cocok, login berhasil
            $response['value'] = 1;
            $response['message'] = "Login Berhasil";
            $response['user_id'] = $row['id']; // Mengembalikan user_id untuk dashboard
            $response['nama'] = $row['nama']; // Mengembalikan nama pengguna
            $response['email'] = $row['email']; // Mengembalikan email pengguna
            $response['foto'] = $row['foto']; // Mengembalikan URL foto pengguna
        } else {
            // Jika password tidak cocok
            $response['value'] = 0;
            $response['message'] = "Login gagal. Password salah.";
        }
    } else {
        // Jika email tidak ditemukan di database
        $response['value'] = 0;
        $response['message'] = "Login gagal. Email tidak ditemukan.";
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

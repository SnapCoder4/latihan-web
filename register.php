<?php

require "connect.php";
session_start();

// Fungsi untuk menghasilkan ID acak yang unik
function generateUniqueID($conn)
{
    do {
        // Generate ID acak antara 100 hingga 999
        $randomID = rand(000, 999);
        // Cek apakah ID sudah ada di database
        $stmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
        $stmt->bind_param("s", $randomID);
        $stmt->execute();
        $result = $stmt->get_result();
    } while ($result->num_rows > 0); // Ulangi jika ID sudah ada
    return str_pad($randomID, 3, '0', STR_PAD_LEFT); // Kembalikan ID dalam format 3 digit
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];
    $nama = $_POST['nama'];
    $alamat = $_POST['alamat'];
    $telepon = $_POST['telepon'];
    $id = generateUniqueID($conn);

    // Cek apakah email sudah terdaftar
    $stmt = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "Email sudah terdaftar, silakan gunakan email lain.";
    } else {
        $target_dir = "foto/";
        $target_file = $target_dir . basename($_FILES["foto"]["name"]);
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

        // Cek format file
        if (in_array($imageFileType, ['jpg', 'jpeg', 'png'])) {
            if (move_uploaded_file($_FILES["foto"]["tmp_name"], $target_file)) {
                $stmt = $conn->prepare("INSERT INTO users (id, email, password, nama, alamat, telepon, foto) 
                                        VALUES (?, ?, ?, ?, ?, ?, ?)");
                $stmt->bind_param("sssssss", $id, $email, $password, $nama, $alamat, $telepon, $target_file);
                if ($stmt->execute()) {
                    echo "Pendaftaran berhasil! ID kamu adalah $id";
                } else {
                    echo "Pendaftaran gagal";
                }
            } else {
                echo "Terjadi kesalahan saat mengupload gambar.";
            }
        } else {
            echo "Hanya format JPG, JPEG, dan PNG yang diizinkan.";
        }
    }
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/register.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Register</title>
</head>

<body>
    <div class="register-container">
        <div class="register-form">
            <h2>Register</h2>
            <form action="" method="post" enctype="multipart/form-data">
                <div class="input-group">
                    <input type="email" id="email" name="email" placeholder="Email" required><i class="fa-solid fa-envelope"></i>
                </div>
                <div class="input-group">
                    <input type="password" id="password" name="password" placeholder="Password" required><i class="fa-solid fa-lock"></i>
                </div>
                <div class="input-group">
                    <input type="text" id="nama" name="nama" placeholder="Nama" required><i class="fa-solid fa-user"></i>
                </div>
                <div class="input-group">
                    <input type="text" id="alamat" name="alamat" placeholder="Alamat" required><i class="fa-solid fa-house"></i>
                </div>
                <div class="input-group">
                    <input type="text" id="telepon" name="telepon" placeholder="Telepon" required><i class="fa-solid fa-phone"></i>
                </div>
                <div class="input-group">
                    <input type="file" id="foto" name="foto" accept=".jpg, .jpeg, .png" required><i class="fa-solid fa-image"></i>
                </div>
                <button type="submit" class="btn btn-primary">Daftar</button>
            </form>
            <p>Sudah punya akun? <a href="login.php">Masukkan akun disini</a></p>
        </div>
    </div>
</body>

</html>
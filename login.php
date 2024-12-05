<?php
require "db_connection.php";
session_start();

$error = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT id, password, nama, foto FROM users WHERE id = ?");
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->bind_result($db_id, $db_password, $db_nama, $db_foto);
        $stmt->fetch();

        // Verifikasi password menggunakan password_verify
        if (password_verify($password, $db_password)) {
            // Simpan informasi user di session
            $_SESSION['id'] = $db_id;
            $_SESSION['nama'] = $db_nama;
            $_SESSION['foto'] = $db_foto;

            header("Location: dashboard.php");
            exit();
        } else {
            $error = "Nomor ID atau Password salah";
        }
    } else {
        $error = "ID tidak ditemukan.";
    }
    $stmt->close();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <title>Login</title>
</head>

<body>
    <div class="login-container">
        <div class="login-form">
            <h2>Login</h2>
            <?php if (!empty($error)): ?>
                <div class="alert alert-danger">
                    <?php echo $error; ?>
                </div>
            <?php endif; ?>
            <form action="" method="post">
                <div class="input-group">
                    <input type="text" id="id" name="id" placeholder="User ID" required><i class="fa-solid fa-user"></i>
                </div>
                <div class="input-group">
                    <input type="password" id="password" name="password" placeholder="Password" required><i class="fa-solid fa-lock"></i>
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            <p>Belum punya akun? <a href="register.php">Buat akun disini</a></p>
        </div>
        <p><a href="forgot_password.php">Lupa password?</a></p>
    </div>
</body>

</html>
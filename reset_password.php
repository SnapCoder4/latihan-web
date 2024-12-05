<?php
require "db_connection.php";

$message = "";

if (isset($_GET['token'])) {
    $token = $_GET['token'];

    // Verifikasi token
    $stmt = $conn->prepare("SELECT id, reset_expires FROM users WHERE reset_token = ?");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        $expires = $user['reset_expires'];

        // Periksa apakah token belum kedaluwarsa
        if (strtotime($expires) > time()) {
            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

                // Update password dan hapus token
                $stmt = $conn->prepare("UPDATE users SET password = ?, reset_token = NULL, reset_expires = NULL WHERE reset_token = ?");
                $stmt->bind_param("ss", $password, $token);
                if ($stmt->execute()) {
                    $message = "Password berhasil diatur ulang. <a href='login.php'>Login</a>";
                } else {
                    $message = "Terjadi kesalahan. Silakan coba lagi.";
                }
            }
        } else {
            $message = "Token reset telah kedaluwarsa.";
        }
    } else {
        $message = "Token tidak valid.";
    }
} else {
    header("Location: forgot_password.php");
    exit();
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login.css">
    <title>Reset Password</title>
</head>

<body>
    <div class="login-container">
        <div class="login-form">
            <h2>Reset Password</h2>
            <?php if (!empty($message)): ?>
                <div class="alert">
                    <?php echo $message; ?>
                </div>
            <?php endif; ?>
            <?php if (empty($message) || strpos($message, 'Token reset telah kedaluwarsa') === false): ?>
                <form action="" method="post">
                    <div class="input-group">
                        <input type="password" name="password" placeholder="Masukkan Password Baru" required><i class="fa-solid fa-lock"></i>
                    </div>
                    <button type="submit" class="btn btn-primary">Reset Password</button>
                </form>
            <?php endif; ?>
        </div>
    </div>
</body>

</html>
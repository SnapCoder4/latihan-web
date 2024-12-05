<?php
require 'db_connection.php';
require 'vendor/autoload.php'; // Autoload PHPMailer

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$message = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];

    // Periksa apakah email terdaftar
    $stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // Generate token dan expiry
        $token = bin2hex(random_bytes(32));
        $expiry = date("Y-m-d H:i:s", strtotime("+1 hour"));

        // Update database
        $stmt = $conn->prepare("UPDATE users SET reset_token = ?, reset_expires = ? WHERE email = ?");
        $stmt->bind_param("sss", $token, $expiry, $email);
        $stmt->execute();

        // Kirim email dengan PHPMailer
        $resetLink = "http://yourwebsite.com/reset_password.php?token=" . $token;

        $mail = new PHPMailer(true);
        try {
            // Konfigurasi SMTP
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = 'your_email@gmail.com'; // Email Anda
            $mail->Password = 'your_email_password'; // Password Email Anda
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port = 587;

            // Pengaturan Email
            $mail->setFrom('your_email@gmail.com', 'Your Website');
            $mail->addAddress($email); // Email tujuan
            $mail->isHTML(true);
            $mail->Subject = 'Password Reset Request';
            $mail->Body = "Klik tautan berikut untuk mengatur ulang password Anda: <a href='$resetLink'>$resetLink</a>";

            $mail->send();
            $message = "Tautan reset password telah dikirim ke email Anda.";
        } catch (Exception $e) {
            $message = "Gagal mengirim email. Error: {$mail->ErrorInfo}";
        }
    } else {
        $message = "Email tidak ditemukan.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login.css">
    <title>Lupa Password</title>
</head>

<body>
    <div class="login-container">
        <div class="login-form">
            <h2>Lupa Password</h2>
            <?php if (!empty($message)): ?>
                <div class="alert">
                    <?php echo $message; ?>
                </div>
            <?php endif; ?>
            <form action="" method="post">
                <div class="input-group">
                    <input type="email" name="email" placeholder="Masukkan Email" required><i class="fa-solid fa-envelope"></i>
                </div>
                <button type="submit" class="btn btn-primary">Kirim Tautan Reset</button>
            </form>
        </div>
    </div>
</body>

</html>
<?php

use PHPMailer\PHPMailer\SMTP;
// Mengatur header agar dapat diakses oleh berbagai sumber (CORS)
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Menghubungkan ke database
require 'db_connection.php';
require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';
require 'vendor/autoload.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = array();

    $email = $_POST['email'] ?? null;

    if (empty($email)) {
        $response['value'] = 0;
        $response['message'] = 'Email tidak boleh kosong.';
        echo json_encode($response);
        exit();
    }

    // Cek apakah email terdaftar
    $query = $connect->prepare("SELECT * FROM users WHERE email = ?");
    $query->bind_param("s", $email);
    $query->execute();
    $result = $query->get_result();

    if ($result->num_rows === 1) {
        $user = $result->fetch_assoc();
        $verificationCode = rand(100000, 999999); // Kode verifikasi 6 angka

        // Simpan kode verifikasi di database
        $updateQuery = $connect->prepare("UPDATE users SET verification_code = ? WHERE email = ?");
        $updateQuery->bind_param("is", $verificationCode, $email);
        $updateQuery->execute();

        // Kirim kode verifikasi ke email
        $mail = new PHPMailer(true);
        try {
            $mail->SMTPDebug = SMTP::DEBUG_OFF;
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = '????@gmail.com'; /* INI GMAIL LU YANG ASLI */
            $mail->Password = 'password'; /* INI GW SIH PAKE PASSWORD APLIKASI DARI GOOGLENYA BUKAN PASSWORD EMAIL ASLI */
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
            $mail->Port = 587;

            $mail->setFrom('Techzone@gmail.com', 'Techzone');
            $mail->addAddress($email);
            $mail->isHTML(true);
            $mail->Subject = 'Kode Verifikasi Reset Password';
            $mail->Body = "<html>
            <body>
            <p>Gunakan kode berikut untuk verifikasi reset password Anda:</p>
            <h2>$verificationCode</h2>
            <p>Masukkan kode verifikasi di aplikasi untuk melanjutkan proses reset password.</p>
            </body></html>";

            $mail->send();

            $response['value'] = 1;
            $response['message'] = 'Kode verifikasi telah dikirim ke email Anda.';
        } catch (Exception $e) {
            $response['value'] = 0;
            $response['message'] = 'Gagal mengirim email. Error: ' . $mail->ErrorInfo;
        }
    } else {
        $response['value'] = 0;
        $response['message'] = 'Email tidak ditemukan.';
    }

    echo json_encode($response);
}
?>
<?php

require "connect.php";
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST["id"];
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT id, password FROM users WHERE id = ? AND password = ?");
    $stmt->bind_param("ss", $id, $password);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // Bind hasil
        $stmt->bind_result($db_id, $db_password);
        $stmt->fetch();

        if ($id == $db_id && $password == $db_password) {
            $_SESSION['id'] = $id;
            header("Location: index.php");
            exit();
        } else {
            $error = "Nomor ID atau Password salah";
        }
    } else {
        $error = "ID tidak ditemukan.";
    }
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
    </div>

</body>

</html>
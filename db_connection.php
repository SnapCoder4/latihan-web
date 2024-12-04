<?php
// Konfigurasi database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_latihan";

// Koneksi ke database
$conn = new mysqli($servername, $username, $password, $dbname);

// Periksa koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

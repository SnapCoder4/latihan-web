<?php
$conn = new mysqli("localhost", "root", "", "db_latihan");

if ($conn->connect_error) {
    echo  "Koneksi gagal";
    die("Connection failed: " . $conn->connect_error);
}
?>
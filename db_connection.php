<?php
$connect = new mysqli("localhost", "root", "", "db_latihan");

// Memeriksa apakah koneksi berhasil
if ($connect->connect_error) {
    echo "Koneksi gagal: " . $connect->connect_error;
    exit();
}

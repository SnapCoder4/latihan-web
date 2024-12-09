<?php
$connect = new mysqli("localhost", "root", "", "db_elektronik");

if ($connect) {
    // Koneksi berhasil
} else {
    echo "Koneksi gagal";
    exit();
}
?>

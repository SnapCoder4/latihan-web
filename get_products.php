<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require 'db_connection.php';

$query = "SELECT * FROM namaproduct";  // Pastikan nama tabel sesuai dengan yang ada di database
$result = mysqli_query($connect, $query);

if ($result) {
    $products = array();

    // Mengambil hasil query dalam array
    while ($row = mysqli_fetch_assoc($result)) {
        $products[] = $row;
    }

    // Mengembalikan data produk sebagai JSON
    echo json_encode($products);
} else {
    echo json_encode(array("message" => "Error in query execution"));
}

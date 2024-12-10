<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require "db_connection.php";

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array(); // Menyimpan respon

    // Mengambil data POST request
    $id_produk = $_POST['id_produk'] ?? null;
    $harga_produk = $_POST['harga_produk'] ?? null;
    $quantity = $_POST['quantity'] ?? 1;
    $tanggal = date("Y-m-d"); // Tanggal pembelian

    if (!empty($harga_produk) && !empty($id_produk)) {
        // Memastikan harga produk adalah angka
        $harga_produk = floatval($harga_produk);

        // Memasukkan data transaksi ke database tanpa idjual
        $stmt = $connect->prepare("INSERT INTO jual (tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssdi", $tanggal, $id_produk, $harga_produk, $quantity);

        if ($stmt->execute()) {
            $response['value'] = 1;
            $response['message'] = 'Pembelian berhasil diproses';
        } else {
            $response['value'] = 0;
            $response['message'] = 'Gagal menyimpan data: ' . $stmt->error;
        }
        $stmt->close();
    } else {
        $response['value'] = 0;
        $response['message'] = 'Field harga_produk dan id_produk tidak boleh kosong.';
    }

    echo json_encode($response);
} else {
    $response['value'] = 0;
    $response['message'] = 'Permintaan tidak valid.';
    echo json_encode($response);
}

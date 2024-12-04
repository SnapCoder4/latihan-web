<?php
require "db_connection.php";
session_start();

if (!isset($_SESSION['id'])) {
    header("Location: login.php");
    exit();
}

$id = $_SESSION['id'];

if (!isset($_POST['id']) || !isset($_POST['quantity'])) {
    die("Data produk atau kuantitas tidak ditemukan.");
}

$productId = $_POST['id'];
$quantity = $_POST['quantity'];

// Ambil data produk dari database
$sql = "SELECT idproduct, product, price FROM namaproduct WHERE idproduct = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $productId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    die("Produk tidak ditemukan.");
}

$product = $result->fetch_assoc();
$stmt->close();

// Format harga
function formatCurrency($price)
{
    return "Rp " . number_format($price, 0, ',', '.');
}

// Ambil nomor transaksi terakhir
$sqlLast = "SELECT MAX(CAST(SUBSTRING(idjual, 2) AS UNSIGNED)) AS last_transaction FROM jual";
$resultLast = $conn->query($sqlLast);

if ($resultLast) {
    $lastTransaction = $resultLast->fetch_assoc();
    $nextTransactionNumber = ($lastTransaction['last_transaction'] !== NULL) ? $lastTransaction['last_transaction'] + 1 : 1;
    // Format nomor transaksi dengan awalan 'J' dan nomor yang diisi dengan 3 digit
    $transactionId = 'J' . str_pad($nextTransactionNumber, 3, '0', STR_PAD_LEFT);
} else {
    die("Query untuk mendapatkan transaksi terakhir gagal: " . $conn->error);
}

// Hitung total harga
$totalPrice = $product['price'] * $quantity;

// Simpan data pembelian ke database
$transactionDate = date('Y-m-d');
$sqlInsert = "INSERT INTO jual (idjual, tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?, ?)";
$stmtInsert = $conn->prepare($sqlInsert);
$stmtInsert->bind_param("ssssi", $transactionId, $transactionDate, $productId, $product['price'], $quantity);

if ($stmtInsert->execute()) {
    echo "<script>alert('Pembelian berhasil untuk $quantity unit {$product['product']} dengan total " . formatCurrency($totalPrice) . "');</script>";
} else {
    echo "<script>alert('Gagal melakukan pembelian. Silakan coba lagi.');</script>";
}

$stmtInsert->close();
$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/beli.css">
    <title>Pembelian</title>
</head>
<body>
    <h1>Pembelian Sukses</h1>
    <p>Terima kasih telah melakukan pembelian. Pembelian Anda telah berhasil diproses.</p>
    <p>Total Pembayaran: <?php echo formatCurrency($totalPrice); ?></p>
    <button onclick="window.location.href='dashboard.php'">Kembali ke Beranda</button>
</body>
</html>

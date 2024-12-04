<?php
require "db_connection.php";
session_start();

if (!isset($_SESSION['id'])) {
    header("Location: login.php");
    exit();
}

$id = $_SESSION['id'];

if (!isset($_GET['id'])) {
    die("ID produk tidak ditemukan.");
}

$productId = $_GET['id'];

// Ambil data produk dari database
$sql = "SELECT product, price, image, description FROM namaproduct WHERE idproduct = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $productId);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    die("Produk tidak ditemukan.");
}

$product = $result->fetch_assoc();
$stmt->close();

// Format harga
function formatCurrency($price) {
    return "Rp " . number_format($price, 0, ',', '.');
}

// Proses pembelian
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Simulasi proses pembelian
    $productName = $product['product'];
    $productPrice = $product['price'];
    $quantity = $_POST['quantity'];

    // Simpan data pembelian ke database
    $sqlInsert = "INSERT INTO penjualan (nama_produk, harga_produk, id_produk, quantity) VALUES (?, ?, ?, ?)";
    $stmtInsert = $conn->prepare($sqlInsert);
    $cleanedPrice = str_replace(['Rp ', '.'], '', formatCurrency($productPrice)); // Membersihkan format harga
    $stmtInsert->bind_param("siis", $productName, $cleanedPrice, $productId, $quantity);
    
    if ($stmtInsert->execute()) {
        echo "<script>alert('Pembelian berhasil untuk $quantity unit $productName dengan total " . formatCurrency($productPrice * $quantity) . "');</script>";
    } else {
        echo "<script>alert('Gagal melakukan pembelian. Silakan coba lagi.');</script>";
    }
    
    $stmtInsert->close();
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Produk - <?= htmlspecialchars($product['product']); ?></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <h1>Detail Produk</h1>
    </header>
    <main>
        <div class="product-detail">
            <img src="<?= htmlspecialchars($product['image']); ?>" alt="<?= htmlspecialchars($product['product']); ?>" onerror="this.src='placeholder.jpg';">
            <h2><?= htmlspecialchars($product['product']); ?></h2>
            <p>Harga: <?= formatCurrency($product['price']); ?></p>
            <p><?= htmlspecialchars($product['description']); ?></p>
            <form method="post">
                <label for="quantity">Kuantitas:</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1" required>
                <button type="submit">Beli Sekarang</button>
            </form>
        </div>
    </main>
</body>
</html>
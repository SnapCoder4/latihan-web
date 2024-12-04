<?php
require "db_connection.php";
session_start();

if (!isset($_SESSION['id'])) {
    header("Location: login.php");
    exit();
}

$id = $_SESSION['id'];
$stmt = $conn->prepare("SELECT nama, foto FROM users WHERE id= ?");
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->bind_result($nama, $target_file);
$stmt->fetch();
$stmt->close();
// Ambil data produk dari tabel namaproduct
$sql = "SELECT idproduct, product, price, image, description FROM namaproduct";
$result = $conn->query($sql);

// Inisialisasi array produk
$products = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
}

// Tutup koneksi
$conn->close();
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Produk</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

</head>

<body>
    <div class="wrapper">
        <header>
            <h1>Dashboard Produk</h1>
        </header>
        <div class="content">
            <div class="container">
                <?php include "sidebar.php"; // Menyertakan sidebar di sini ?>
                <main>
                    <h2>Selamat Berbelanja</h2>
                    <div class="grid-container">
                        <?php if (!empty($products)): ?>
                            <?php foreach ($products as $product): ?>
                                <div class="card">
                                    <img src="<?= htmlspecialchars($product['image']); ?>"
                                        alt="<?= htmlspecialchars($product['product']); ?>"
                                        onerror="this.src='placeholder.jpg';">
                                    <div class="details">
                                        <h3><?= htmlspecialchars($product['product']); ?></h3>
                                        <p>Rp <?= number_format($product['price'], 0, ',', '.'); ?></p>
                                        <button
                                            onclick="window.location.href='product_detail.php?id=<?= $product['idproduct']; ?>';">Beli</button>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <p>Tidak ada produk tersedia.</p>
                        <?php endif; ?>
                    </div>
                </main>
            </div>
        </div>
    </div>

    <script src="js/script.js"></script>
</body>

</html>
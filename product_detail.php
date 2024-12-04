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
$sql = "SELECT idproduct, product, price, image, description FROM namaproduct WHERE idproduct = ?";
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

// Proses pembelian
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $quantity = $_POST['quantity'];
    $productName = $product['product'];
    $productPrice = $product['price'];
    $transactionDate = date('Y-m-d');

    $resultLast = $conn->query( "SELECT MAX(idjual) AS last_idjual FROM jual");
    $lastTransaction = $resultLast->fetch_assoc();

    if ($resultLast) {
        $lastTransaction = $resultLast->fetch_assoc();
        if ($lastTransaction && $lastTransaction['last_transaction'] !== NULL) {
            $nextTransactionNumber = $lastTransaction['last_transaction'] + 1; // Menambah nomor urut
        } else {
            $nextTransactionNumber = 1; // Jika tidak ada transaksi sebelumnya, mulai dari 1
        }
    }

    // Simpan data pembelian ke database
    $sqlInsert = "INSERT INTO jual (idjual, tgljual, idproduct, price, quantity) VALUES (?, ?, ?, ?, ?)";
    $stmtInsert = $conn->prepare($sqlInsert);
    $stmtInsert->bind_param("ssssi", $nextTransactionNumber, $transactionDate, $productId, $productPrice, $quantity);

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
    <link rel="stylesheet" href="css/product_detail.css">
</head>

<body>
    <header>
        <h1>Detail Produk</h1>
    </header>

    <main>
        <section class="product-detail">
            <div class="product-image">
                <img src="<?= htmlspecialchars($product['image']); ?>" alt="<?= htmlspecialchars($product['product']); ?>" onerror="this.src='placeholder.jpg';">
            </div>
            <div class="product-info">
                <h2><?= htmlspecialchars($product['product']); ?></h2>
                <p class="price">Harga: <?= formatCurrency($product['price']); ?></p>
                <p class="description"><?= nl2br(htmlspecialchars($product['description'])); ?></p>
                <form method="post">
                    <label for="quantity">Kuantitas:</label>
                    <input type="number" id="quantity" name="quantity" value="1" min="1" required>
                    <button type="submit">Beli Sekarang</button>
                </form>
            </div>
        </section>

        <a href="dashboard.php"><button class="back-button">Kembali</button></a>
    </main>
</body>

</html>

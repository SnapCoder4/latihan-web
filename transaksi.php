<?php
require "db_connection.php"; // Connect to the database
session_start();

// Ensure user is logged in
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

// Fetch transaction data from the 'jual' table
$sql = "SELECT idjual, tgljual, idproduct, price, quantity FROM jual";
$result = $conn->query($sql);

// Check if data exists
if ($result->num_rows === 0) {
    $message = "Tidak ada transaksi yang ditemukan.";
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Data Transaksi</title>
    <link rel="stylesheet" href="css/styles.css"> <!-- Link to external CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const body = document.body;
            const toggleButton = document.getElementById('modeToggle');
            const moonIcon = document.getElementById('moonIcon');
            const sunIcon = document.getElementById('sunIcon');

            // Cek preferensi mode dari localStorage dan terapkan jika ada
            if (localStorage.getItem('theme') === 'dark') {
                body.classList.add('dark-mode'); // Aktifkan dark mode jika preferensi pengguna adalah dark
                moonIcon.style.display = 'none'; // Sembunyikan ikon bulan
                sunIcon.style.display = 'inline'; // Tampilkan ikon matahari
            }

            // Menangani klik pada tombol toggle
            toggleButton.addEventListener('click', function () {
                body.classList.toggle('dark-mode'); // Menambah atau menghapus class 'dark-mode'

                // Mengubah tampilan ikon
                if (body.classList.contains('dark-mode')) {
                    moonIcon.style.display = 'none'; // Sembunyikan ikon bulan
                    sunIcon.style.display = 'inline'; // Tampilkan ikon matahari
                } else {
                    sunIcon.style.display = 'none'; // Sembunyikan ikon matahari
                    moonIcon.style.display = 'inline'; // Tampilkan ikon bulan
                }

                // Simpan preferensi mode ke localStorage
                if (body.classList.contains('dark-mode')) {
                    localStorage.setItem('theme', 'dark');
                } else {
                    localStorage.setItem('theme', 'light');
                }
            });
        });
    </script>


</head>

<body>
    <div class="wrapper">
        <header>
            <h1>Data Transaksi</h1>
            <button id="modeToggle" title="Toggle Mode">
                <i class="fas fa-moon" id="moonIcon"></i> <!-- Ikon untuk mode gelap -->
                <i class="fas fa-sun" id="sunIcon"></i> <!-- Ikon untuk mode terang -->
            </button>

        </header>

        <div class="content">
            <div class="container">
                <?php include "sidebar.php"; ?> <!-- Sidebar inclusion -->
                <main>
                    <?php if (isset($message)): ?>
                        <div class="alert alert-warning">
                            <p><?php echo $message; ?></p>
                        </div>
                    <?php else: ?>
                        <table class="transaction-table">
                            <thead>
                                <tr>
                                    <th>ID Transaksi</th>
                                    <th>Tanggal Transaksi</th>
                                    <th>ID Produk</th>
                                    <th>Harga</th>
                                    <th>Kuantitas</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php while ($row = $result->fetch_assoc()): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($row['idjual']); ?></td>
                                        <td><?php echo htmlspecialchars($row['tgljual']); ?></td>
                                        <td><?php echo htmlspecialchars($row['idproduct']); ?></td>
                                        <td><?php echo "Rp " . number_format($row['price'], 0, ',', '.'); ?></td>
                                        <td><?php echo htmlspecialchars($row['quantity']); ?></td>
                                    </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    <?php endif; ?>

                    <!-- Tombol untuk menghasilkan PDF -->
                    <a href="generate_pdf.php" class="btn">Download PDF</a>
                </main>
            </div>
        </div>
    </div>
    <script src="js/script.js"></script>
</body>

</html>
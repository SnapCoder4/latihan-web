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

// Pagination logic
$limit = 10; // Number of items per page
$page = isset($_GET['page']) ? (int) $_GET['page'] : 1;
$offset = ($page - 1) * $limit;

// Ambil tahun dan bulan dari form filter
$year = isset($_GET['year']) ? (int) $_GET['year'] : date("Y");
$month = isset($_GET['month']) ? (int) $_GET['month'] : date("m");

// Fetch transaction data from the 'jual' table with pagination and filter
$sql = "SELECT idjual, tgljual, idproduct, price, quantity, (price * quantity) AS total_price 
        FROM jual 
        WHERE YEAR(tgljual) = ? AND MONTH(tgljual) = ? 
        LIMIT ?, ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("iiii", $year, $month, $offset, $limit);
$stmt->execute();
$result = $stmt->get_result();

// Check if data exists
if ($result->num_rows === 0) {
    $message = "Tidak ada transaksi yang ditemukan.";
}

// Count total number of records for pagination
$countStmt = $conn->prepare("SELECT COUNT(*) FROM jual WHERE YEAR(tgljual) = ? AND MONTH(tgljual) = ?");
$countStmt->bind_param("ii", $year, $month);
$countStmt->execute();
$countStmt->bind_result($totalRecords);
$countStmt->fetch();
$countStmt->close();

$totalPages = ceil($totalRecords / $limit); // Total pages

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
    <style>
        /* Pagination container */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            margin-bottom: 20px;
            list-style-type: none;
        }

        /* Pagination links */
        .pagination a {
            color: #007bff;
            text-decoration: none;
            padding: 8px 16px;
            margin: 0 5px;
            border-radius: 4px;
            border: 1px solid #ddd;
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        /* Pagination links on hover */
        .pagination a:hover {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        /* Active page */
        .pagination .active a {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
            font-weight: bold;
        }

        /* Disabled page (Previous/Next) */
        .pagination .disabled a {
            color: #ccc;
            pointer-events: none;
            border-color: #ddd;
        }

        /* Pagination ellipsis */
        .pagination .ellipsis {
            padding: 8px 16px;
            color: #007bff;
        }

        /* Styling for first, previous, next, and last buttons */
        .pagination .prev,
        .pagination .next,
        .pagination .first,
        .pagination .last {
            background-color: #f1f1f1;
            border-color: #ddd;
            padding: 8px 16px;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .pagination .prev:hover,
        .pagination .next:hover,
        .pagination .first:hover,
        .pagination .last:hover {
            background-color: #007bff;
            color: white;
        }
    </style>
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
                            <a href="transaksi.php" class="btn">Kembali ke Tabel Awal</a> <!-- Tombol Reset -->
                        </div>
                    <?php else: ?>
                        <form method="GET" action="transaksi.php">
                            <label for="year">Tahun:</label>
                            <select name="year" id="year">
                                <?php
                                // Mengambil tahun dari database atau membuat array tahun
                                for ($i = date("Y"); $i >= 2000; $i--) {
                                    $selected = ($i == $year) ? "selected" : "";
                                    echo "<option value='$i' $selected>$i</option>";
                                }
                                ?>
                            </select>

                            <label for="month">Bulan:</label>
                            <select name="month" id="month">
                                <?php
                                $months = [
                                    "01" => "Januari",
                                    "02" => "Februari",
                                    "03" => "Maret",
                                    "04" => "April",
                                    "05" => "Mei",
                                    "06" => "Juni",
                                    "07" => "Juli",
                                    "08" => "Agustus",
                                    "09" => "September",
                                    "10" => "Oktober",
                                    "11" => "November",
                                    "12" => "Desember"
                                ];
                                foreach ($months as $key => $value) {
                                    $selected = ($key == $month) ? "selected" : "";
                                    echo "<option value='$key' $selected>$value</option>";
                                }
                                ?>
                            </select>

                            <button type="submit">Filter</button>
                        </form>

                        <table class="transaction-table">
                            <thead>
                                <tr>
                                    <th>ID Transaksi</th>
                                    <th>Tanggal Transaksi</th>
                                    <th>ID Produk</th>
                                    <th>Harga</th>
                                    <th>Kuantitas</th>
                                    <th>Total Harga</th> <!-- Kolom baru untuk total harga -->
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
                                        <td><?php echo "Rp " . number_format($row['total_price'], 0, ',', '.'); ?></td>
                                        <!-- Menampilkan total harga -->
                                    </tr>
                                <?php endwhile; ?>
                            </tbody>
                        </table>
                    <?php endif; ?>

                    <!-- Pagination -->
                    <nav>
                        <ul class="pagination justify-content-center">
                            <?php for ($p = 1; $p <= $totalPages; $p++): ?>
                                <li class="page-item <?= $p == $page ? 'active' : ''; ?>">
                                    <a class="page-link" href="?page=<?= $p; ?>&year=<?= $year; ?>&month=<?= $month; ?>"><?= $p; ?></a>
                                </li>
                            <?php endfor; ?>
                        </ul>
                    </nav>

                    <!-- Tombol untuk menghasilkan PDF -->
                    <a href="generate_pdf.php?year=<?= $year; ?>&month=<?= $month; ?>" class="btn">Download PDF</a>
                </main>
            </div>
        </div>
    </div>
    <script src="js/script.js"></script>
</body>

</html>
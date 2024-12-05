<?php
session_start();
require "config.php";

if (!isset($_SESSION['iduser'])) {
    header("Location: login.php");
    exit();
}

$iduser = $_SESSION['iduser'];

// Ambil data user dari database
$stmt = $conn->prepare("SELECT username, email FROM login WHERE iduser = ?");
$stmt->bind_param("i", $iduser);
$stmt->execute();
$stmt->bind_result($username, $useremail);
$stmt->fetch();
$stmt->close();

// Ambil data nama perusahaan dari tabel namausaha
$stmt = $conn->prepare("SELECT nama, alamat FROM namausaha LIMIT 1");
$stmt->execute();
$stmt->bind_result($namaUsaha, $alamatUsaha);
$stmt->fetch();
$stmt->close();

// Pagination logic
$limit = 5; // Number of items per page
$page = isset($_GET['page']) ? (int) $_GET['page'] : 1;
$offset = ($page - 1) * $limit;

// Ambil data dari tabel stok
$stmt = $conn->prepare("SELECT id_barang, nomorbarang, nama_barang, kategori, jumlah_stok, harga_satuan, foto FROM stok LIMIT ?, ?");
$stmt->bind_param("ii", $offset, $limit);
$stmt->execute();
$result = $stmt->get_result();

// Calculate starting ID for this page
$i = $offset + 1; // Start ID for the current page

// Count total number of records for pagination
$countStmt = $conn->prepare("SELECT COUNT(*) FROM stok");
$countStmt->execute();
$countStmt->bind_result($totalRecords);
$countStmt->fetch();
$countStmt->close();

$totalPages = ceil($totalRecords / $limit); // Total pages
?>

<?php require 'head.php'; ?>
<div class="wrapper">
    <header>
        <!-- Menampilkan nama PT di sebelah kiri atas -->
        <?php if (isset($namaUsaha) && isset($alamatUsaha)): ?>
            <h4><?php echo htmlspecialchars($namaUsaha); ?></h4>
            <p><?php echo htmlspecialchars($alamatUsaha); ?></p>
        <?php else: ?>
            <h4>Identitas Usaha Belum Tersedia</h4>
            <p>Silakan tambahkan identitas usaha.</p>
        <?php endif; ?>
    </header>

    <?php include 'sidebar.php'; ?>

    <div class="content" id="content">
        <div class="container-fluid mt-3 table-bordered">
            <h6 style="background-color: rgba(128, 128, 128, 0.08)" class="mt-3">Daftar Stok Barang</h6>
            <div class="col-md-12 mb-3">
                <input type="text" id="searchInput" class="form-control" placeholder="Cari barang..."
                    autocomplete="off">
            </div>
            <table class="table table-striped table-bordered" id="stokTable">
                <thead>
                    <tr>
                        <th>No</th>
                        <th>ID</th>
                        <th>Nama Barang</th>
                        <th>Kategori</th>
                        <th>Jumlah Stok</th>
                        <th>Harga Satuan</th>
                        <th>Foto</th>
                        <th>Tindakan</th>
                    </tr>
                </thead>
                <tbody id="stokBody">
                    <?php while ($row = $result->fetch_assoc()): ?>
                        <tr>
                            <td><?= $i; ?></td>
                            <td><?= htmlspecialchars($row['nomorbarang']); ?></td>
                            <td><?= htmlspecialchars($row['nama_barang']); ?></td>
                            <td><?= htmlspecialchars($row['kategori']); ?></td>
                            <td><?= htmlspecialchars($row['jumlah_stok']); ?></td>
                            <td><?= htmlspecialchars($row['harga_satuan']); ?></td>
                            <td>
                                <img src="foto/<?= htmlspecialchars($row['foto']); ?>" alt="Foto" class="img-thumbnail"
                                    style="width: 150px; height: auto;">
                            </td>
                            <td>
                                <a href="#" class="btn btn-warning btn-sm edit-btn" data-id="<?= $row['id_barang']; ?>"
                                    data-nomor="<?= htmlspecialchars($row['nomorbarang']); ?>"
                                    data-nama="<?= htmlspecialchars($row['nama_barang']); ?>"
                                    data-kategori="<?= htmlspecialchars($row['kategori']); ?>"
                                    data-jumlah="<?= htmlspecialchars($row['jumlah_stok']); ?>"
                                    data-harga="<?= htmlspecialchars($row['harga_satuan']); ?>"
                                    data-foto="<?= htmlspecialchars($row['foto']); ?>" data-bs-toggle="modal"
                                    data-bs-target="#editBarangModal">Edit</a>
                                <a href="hapus_stok.php?id_barang=<?= $row['id_barang']; ?>" class="btn btn-danger btn-sm"
                                    onclick="return confirm('Apakah Anda yakin ingin menghapus barang ini?');">Hapus</a>
                            </td>
                        </tr>
                        <?php $i++; ?> <!-- Increment for next row -->
                    <?php endwhile; ?>
                </tbody>
            </table>

            <!-- Pagination -->
            <nav>
                <ul class="pagination justify-content-center">
                    <?php for ($p = 1; $p <= $totalPages; $p++): ?>
                        <li class="page-item <?= $p == $page ? 'active' : ''; ?>">
                            <a class="page-link" href="?page=<?= $p; ?>"><?= $p; ?></a>
                        </li>
                    <?php endfor; ?>
                </ul>
            </nav>

            <div class="d-flex justify-content-end mb-3">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                    data-bs-target="#addBarangModal">Tambah Barang</button>
                <button type="button" class="btn btn-secondary ml-2" id="printButton"> Print</button>
            </div>
        </div>

        <!-- Modal Add Barang -->
        <div class="modal fade" id="addBarangModal" tabindex="-1" aria-labelledby="addBarangModalLabel"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addBarangModalLabel">Tambah Barang</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form action="tambah_stok.php" method="post" enctype="multipart/form-data">
                            <div class="mb-3">
                                <label for="nomorbarang" class="form-label">ID Barang (Nomor)</label>
                                <input type="text" class="form-control" id="nomorbarang" name="nomorbarang" required>
                            </div>
                            <div class="mb-3">
                                <label for="nama_barang" class="form-label">Nama Barang</label>
                                <input type="text" class="form-control" id="nama_barang" name="nama_barang" required>
                            </div>
                            <div class="mb-3">
                                <label for="kategori" class="form-label">Kategori</label>
                                <input type="text" class="form-control" id="kategori" name="kategori" required>
                            </div>
                            <div class="mb-3">
                                <label for="jumlah_stok" class="form-label">Jumlah Stok</label>
                                <input type="number" class="form-control" id="jumlah_stok" name="jumlah_stok" required>
                            </div>
                            <div class="mb-3">
                                <label for="harga_satuan" class="form-label">Harga Satuan</label>
                                <input type="number" class="form-control" id="harga_satuan" name="harga_satuan"
                                    required>
                            </div>
                            <div class="mb-3">
                                <label for="foto" class="form-label">Foto</label>
                                <input type="file" class="form-control" id="foto" name="foto" accept="image/*" required>
                            </div>
                            <div>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Save</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal Edit Barang -->
    <div class="modal fade" id="editBarangModal" tabindex="-1" aria-labelledby="editBarangModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editBarangModalLabel">Edit Barang</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editForm" action="edit_stok.php" method="post" enctype="multipart/form-data">
                        <input type="hidden" id="edit_id_barang" name="id_barang">
                        <div class="mb-3">
                            <label for="edit_nomorbarang" class="form-label">ID Barang (Nomor)</label>
                            <input type="text" class="form-control" id="edit_nomorbarang" name="nomorbarang" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit_nama_barang" class="form-label">Nama Barang</label>
                            <input type="text" class="form-control" id="edit_nama_barang" name="nama_barang" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit_kategori" class="form-label">Kategori</label>
                            <input type="text" class="form-control" id="edit_kategori" name="kategori" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit_jumlah_stok" class="form-label">Jumlah Stok</label>
                            <input type="number" class="form-control" id="edit_jumlah_stok" name="jumlah_stok" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit_harga_satuan" class="form-label">Harga Satuan</label>
                            <input type="number" class="form-control" id="edit_harga_satuan" name="harga_satuan"
                                required>
                        </div>
                        <div class="mb-3">
                            <label for="edit_foto" class="form-label">Foto</label>
                            <input type="file" class="form-control" id="edit_foto" name="foto" accept="image/*"
                                required>
                        </div>
                        <div>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>




    <?php require 'footer.php'; ?>
</div>

<!-- Bootstrap JavaScript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link href="//cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet">

<script>
    $(document).ready(function () {
        // Display success or error messages after adding, editing, or deleting
        <?php if (isset($_SESSION['message'])): ?>
            Swal.fire({
                title: '<?php echo $_SESSION['message']['type'] === 'success' ? 'Success!' : 'Error!'; ?>',
                text: '<?php echo $_SESSION['message']['text']; ?>',
                icon: '<?php echo $_SESSION['message']['type'] === 'success' ? 'success' : 'error'; ?>'
            });
            <?php unset($_SESSION['message']); ?>
        <?php endif; ?>

        // Live search functionality
        $('#searchInput').on('keyup', function () {
            var value = $(this).val().toLowerCase();
            $('#stokBody tr').filter(function () {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
        //print pdf
        $('#printButton').click(function() {
                window.location.href = 'print_stok.php';
            });
    });
    $(document).on('click', '.edit-btn', function () {
        $('#edit_id_barang').val($(this).data('id'));
        $('#edit_nomorbarang').val($(this).data('nomor'));
        $('#edit_nama_barang').val($(this).data('nama'));
        $('#edit_kategori').val($(this).data('kategori'));
        $('#edit_jumlah_stok').val($(this).data('jumlah'));
        $('#edit_harga_satuan').val($(this).data('harga'));
        var foto = $(this).data('foto');
        $('#editBarangModal .modal-body').find('.current-foto').attr('src', 'foto/' + foto);
    });

</script>
</body>

</html>
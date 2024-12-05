<div class="sidebar" id="sidebar">
    <div class="user-info">
        <img src="<?= htmlspecialchars($_SESSION['foto']); ?>" alt="Foto Pengguna" class="user-photo">
        <h5 class="username"><?= htmlspecialchars($_SESSION['nama']); ?></h5>
    </div>
    <ul>
        <li><a href="dashboard.php"><i class="fas fa-home"></i> <span class="menu-text">Produk</span></a></li>
        <li><a href="transaksi.php"><i class="fas fa-building"></i> <span class="menu-text">Transaksi</span></a></li>
        <li>
            <a href="#" onclick="confirmLogout(event)">
                <i class="fas fa-sign-out-alt"></i> <span class="menu-text">Logout</span>
            </a>
        </li>
    </ul>
    <button id="toggleSidebarButton" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
</div>

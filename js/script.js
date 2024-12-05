// Tambahkan interaktivitas jika diperlukan, misalnya logout
document.getElementById('logoutButton').addEventListener('click', function () {
    if (confirm('Apakah Anda yakin ingin logout?')) {
        window.location.href = 'login.php';
    }
});

// Contoh fungsi untuk memuat placeholder jika gambar gagal dimuat
document.addEventListener('DOMContentLoaded', function () {
    const images = document.querySelectorAll('img');
    images.forEach(image => {
        image.onerror = function () {
            this.src = 'assets/images/placeholder.jpg'; // Ganti dengan path placeholder Anda
        };
    });
});

function toggleSidebar() {
    // Ambil elemen yang terkait
    const sidebar = document.querySelector('.sidebar');
    const content = document.querySelector('.content');
    const header = document.querySelector('header');
    const toggleButton = document.querySelector('#toggleSidebarButton');

    toggleButton.addEventListener('click', () => {
        // Toggle kelas 'collapsed' untuk sidebar, header, dan content
        sidebar.classList.toggle('collapsed');
        content.classList.toggle('collapsed');
        header.classList.toggle('collapsed');
    });

}

function searchProducts() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toLowerCase();
    const productGrid = document.getElementById('productGrid');
    const cards = productGrid.getElementsByClassName('card');

    for (let i = 0; i < cards.length; i++) {
        const title = cards[i].getElementsByClassName('details')[0].getElementsByTagName('h3')[0];
        if (title) {
            const txtValue = title.textContent || title.innerText;
            if (txtValue.toLowerCase().indexOf(filter) > -1) {
                cards[i].style.display = "";
            } else {
                cards[i].style.display = "none";
            }
        }
    }
}

function confirmLogout(event) {
    event.preventDefault(); // Mencegah tautan logout langsung dieksekusi
    const confirmed = confirm("Apakah Anda yakin ingin logout?");
    if (confirmed) {
        window.location.href = 'logout.php'; // Redirect ke logout.php jika dikonfirmasi
    }
}





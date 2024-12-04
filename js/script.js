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




import 'storeratings.dart';
import 'deskripsi_toko.dart';
import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Impor halaman Edit Profile

class SettingsPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final int userId; // ID pengguna untuk digunakan di Edit Profile
  final String currentName; // Nama pengguna saat ini
  final String currentEmail; // Email pengguna saat ini
  final String currentPhoto; // Foto pengguna saat ini (URL atau kosong)

  SettingsPage({
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhoto,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSettingsOption(
            icon: Icons.person,
            title: 'Edit Profil',
            onTap: () async {
              // Navigasi ke EditProfilePage dan menunggu data yang diperbarui
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    toggleTheme: widget.toggleTheme,
                    isDarkMode: widget.isDarkMode,
                    userId: widget.userId,
                    currentName: widget.currentName,
                    currentEmail: widget.currentEmail,
                    currentPhoto: widget.currentPhoto,
                  ),
                ),
              );

              // Kirim data yang diperbarui kembali ke halaman sebelumnya
              if (updatedData != null) {
                Navigator.pop(context, updatedData);
              }
            },
          ),
          _buildSettingsOption(
            icon: Icons.info_outline,
            title: 'Tentang Kami',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeskripsiTokoPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.star_border,
            title: 'Nilai Toko Kami',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreRatingsPage()),
              );
            },
          ),
          _buildSettingsOption(
            icon: Icons.color_lens,
            title: 'Ganti Tema',
            onTap: widget.toggleTheme, // Toggle tema gelap/terang
          ),
        ],
      ),
    );
  }

  // Helper method to build each settings option
  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

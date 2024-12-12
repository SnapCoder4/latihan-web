import 'package:flutter/material.dart';
import 'edit_profile_page.dart'; // Impor halaman Edit Profile

class SettingsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profil'),
            onTap: () async {
              // Navigasi ke EditProfilePage
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    userId: userId,
                    currentName: currentName,
                    currentEmail: currentEmail,
                    currentPhoto: currentPhoto,
                  ),
                ),
              );

              // Kirim data yang diperbarui kembali ke halaman sebelumnya
              if (updatedData != null) {
                Navigator.pop(context, updatedData);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Ganti Tema'),
            onTap: toggleTheme,
          ),
        ],
      ),
    );
  }
}

import 'edit_profil.dart';
import 'storeratings.dart';
import 'deskripsi_toko.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
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

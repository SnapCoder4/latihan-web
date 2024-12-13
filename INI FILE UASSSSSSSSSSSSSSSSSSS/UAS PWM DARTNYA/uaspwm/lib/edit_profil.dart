import 'dart:convert';
import 'dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  String _message = '';

  // Method untuk mengupdate profil
  Future<void> _updateProfile() async {
    // Ambil ID pengguna dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('user_id') ?? '';

    final nama = _namaController.text;
    final alamat = _alamatController.text;
    final telepon = _teleponController.text;

    var uri = Uri.parse("http://localhost/UASPWM/editprofil.php");

    try {
      var response = await http.post(uri, body: {
        'id': userId, // Kirim ID pengguna
        'nama': nama,
        'alamat': alamat,
        'telepon': telepon,
      });

      print('Response body: ${response.body}'); // Debugging response

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['value'] == 1) {
          setState(() {
            _message = "Profile updated successfully!";
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          );
        } else {
          setState(() {
            _message = "Error updating profile: ${jsonData['message']}";
          });
        }
      } else {
        setState(() {
          _message =
              "Error: Failed to update profile. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _message =
            "Error: Failed to connect to the server. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Stack(
        children: [
          // Form Edit Profile
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _teleponController,
                      decoration: InputDecoration(
                        labelText: 'Telepon',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text('Update Profile'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _message,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

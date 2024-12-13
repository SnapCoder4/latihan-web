import 'login.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final String email;

  ChangePasswordPage(
      {required this.email,
      required this.isDarkMode,
      required this.toggleTheme});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _message = '';

  Future<void> _changePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _message = "Semua field wajib diisi.";
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _message = "Password tidak cocok.";
      });
      return;
    }

    final String url = 'http://192.168.0.149/UASPWM/resetform.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': widget.email,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['value'] == 1) {
          setState(() {
            _message = "Password berhasil diubah, silakan login kembali.";
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                      toggleTheme: widget.toggleTheme,
                      isDarkMode: widget.isDarkMode)),
            );
          });
        } else {
          setState(() {
            _message = jsonResponse['message'];
          });
        }
      } else {
        setState(() {
          _message = 'Terjadi kesalahan, silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Tidak dapat terhubung ke server.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
                context); // Tombol untuk kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ganti Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Masukkan password baru',
                    hintStyle: TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Konfirmasi password baru',
                    hintStyle: TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    prefixIcon: Icon(Icons.lock, color: Colors.black),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.3, vertical: 16),
                  ),
                  child: Text(
                    'Ganti Password',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('berhasil')
                        ? Colors.green
                        : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

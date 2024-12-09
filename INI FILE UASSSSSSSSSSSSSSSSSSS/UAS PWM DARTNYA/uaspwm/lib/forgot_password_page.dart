import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';

  Future<void> _resetPassword() async {
    final email = _emailController.text;

    // Validasi email
    if (email.isEmpty) {
      setState(() {
        _message = "Email tidak boleh kosong.";
      });
      return;
    }

    // URL endpoint API untuk reset password
    final String url = 'http://localhost/UASPWM/reset_password.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['value'] == 1) {
          // Jika reset password berhasil
          setState(() {
            _message = "Link reset password telah dikirim ke email Anda.";
          });
        } else {
          // Jika email tidak ditemukan
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Lupa Password')),
      body: Stack(
        children: [
          // Gambar latar belakang
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover, // Mengisi seluruh latar belakang
            ),
          ),

          // Konten di atas gambar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo di bagian atas
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/logo.jpg'), // Sesuaikan dengan path logo
                  ),
                ),
                SizedBox(height: 24),

                // Pesan di bawah logo, margin sama dengan input email
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'Lupa Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),

                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'PESAN PENTING:',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),

                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: Text(
                      'Masukkan email Anda dan link reset password akan dikirimkan.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: Colors.white
                            .withOpacity(0.8), // Transparansi untuk kontras
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Tombol Reset Password
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.6,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text('Reset Password'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Bentuk kapsul
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 16), // Ukuran tinggi tombol
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    _message,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

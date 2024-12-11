import 'dart:convert';
import 'reset_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerificationPage extends StatefulWidget {
  final String email;

  VerificationPage({required this.email});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();
  String _message = '';

  Future<void> _verifyCode() async {
    final verificationCode = _verificationCodeController.text;

    if (verificationCode.isEmpty) {
      setState(() {
        _message = 'Kode verifikasi harus diisi.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost/UASPWM/verifycode.php'),
        body: {
          'verification_code': verificationCode,
          'email': widget.email,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _message = responseData['message'];
        });

        if (responseData['value'] == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChangePasswordPage(email: widget.email)),
          );
        }
      } else {
        setState(() {
          _message = 'Terjadi kesalahan: ${response.statusCode}';
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
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Konten di atas gambar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Judul halaman
                Text(
                  'Verifikasi Kode',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),

                // Pesan instruksi
                Text(
                  'Masukkan kode verifikasi yang telah dikirimkan ke email Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),

                // TextField untuk kode verifikasi
                TextField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    labelText: 'Kode Verifikasi',
                    labelStyle: TextStyle(color: Colors.black),
                    hintText: 'Masukkan kode di sini',
                    hintStyle: TextStyle(color: Colors.black38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    prefixIcon: Icon(Icons.security, color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 24),

                // Tombol Verifikasi
                ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.3, vertical: 16),
                  ),
                  child: Text(
                    'Verifikasi',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 16),

                // Pesan error atau status
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

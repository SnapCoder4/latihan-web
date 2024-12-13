import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart'; // Impor halaman register
import 'dashboard_page.dart'; // Impor halaman dashboard
import 'forgot_password_page.dart'; // Impor halaman lupa password

class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme; // Callback untuk mengganti tema
  final bool isDarkMode; // Indikator apakah dark mode aktif

  LoginPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _message = 'Email dan password tidak boleh kosong.';
      });
      return;
    }

    final String url = 'http://192.168.0.149/UASPWM/login.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['value'] == 1) {
          // Convert user_id from string to int
          final int userId = int.parse(jsonResponse['user_id']);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(
                toggleTheme: widget.toggleTheme,
                isDarkMode: widget.isDarkMode,
                userId: userId,
              ),
            ),
          );
        } else {
          setState(() {
            _message = jsonResponse['message'] ?? 'Login gagal.';
          });
        }
      } else {
        setState(() {
          _message = 'Terjadi kesalahan server. Kode: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _message = 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Gambar latar belakang
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten login
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo berbentuk lingkaran
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                  ),
                  SizedBox(height: 24),

                  // TextField email
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: widget.isDarkMode
                            ? Colors.grey[800]
                            : Colors.white.withOpacity(0.8),
                      ),
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // TextField password
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: widget.isDarkMode
                            ? Colors.grey[800]
                            : Colors.white.withOpacity(0.8),
                      ),
                      style: TextStyle(
                        color: widget.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),

                  // Link lupa password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(
                              toggleTheme: widget.toggleTheme,
                              isDarkMode: widget.isDarkMode,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: widget.isDarkMode ? Colors.white : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tombol login dan register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _login,
                        child: Text('Login'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                toggleTheme: widget.toggleTheme,
                                isDarkMode: widget.isDarkMode,
                              ),
                            ),
                          );
                        },
                        child: Text('Register'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Pesan error
                  if (_message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _message,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

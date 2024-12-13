import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dashboard_page.dart';
import 'login.dart'; // Hanya digunakan jika ada navigasi ke halaman Login

class RegisterPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  RegisterPage({required this.toggleTheme, required this.isDarkMode});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();

  String _message = '';
  Uint8List? _selectedFileBytes; // Untuk menyimpan data file gambar
  String? _selectedFileName; // Nama file gambar yang dipilih
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar menggunakan kamera atau galeri
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedFileBytes = bytes;
          _selectedFileName = pickedFile.name;
        });
      } else {
        setState(() {
          _message = 'Gagal memilih gambar.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan saat memilih gambar: $e';
      });
    }
  }

  // Fungsi untuk mengirim data registrasi ke server
  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final nama = _namaController.text;
    final alamat = _alamatController.text;
    final telepon = _teleponController.text;

    if (email.isEmpty ||
        password.isEmpty ||
        nama.isEmpty ||
        alamat.isEmpty ||
        telepon.isEmpty) {
      setState(() {
        _message = 'Semua field wajib diisi!';
      });
      return;
    }

    final uri = Uri.parse('http://192.168.1.2/lat_login/register.php');
    final request = http.MultipartRequest('POST', uri);

    // Tambahkan field input ke request
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['nama'] = nama;
    request.fields['alamat'] = alamat;
    request.fields['telepon'] = telepon;

    // Jika ada gambar, tambahkan ke request
    if (_selectedFileBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          _selectedFileBytes!,
          filename: _selectedFileName,
        ),
      );
    }

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData.body);

        if (jsonResponse['value'] == 1) {
          // Berhasil registrasi, navigasi ke Dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(
                toggleTheme: widget.toggleTheme,
                isDarkMode: widget.isDarkMode,
                userId: jsonResponse['user_id'], // ID pengguna dari server
              ),
            ),
          );
        } else {
          setState(() {
            _message = jsonResponse['message'];
          });
        }
      } else {
        setState(() {
          _message = 'Registrasi gagal. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Kesalahan jaringan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            // Pilihan gambar
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _selectedFileBytes != null
                    ? MemoryImage(_selectedFileBytes!)
                    : null,
                child: _selectedFileBytes == null
                    ? Icon(Icons.add_a_photo, size: 50)
                    : null,
              ),
            ),
            TextButton(
              onPressed: _pickImage,
              child: Text('Pilih Foto'),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Input Nama
            _buildTextField(
              controller: _namaController,
              label: 'Nama',
              icon: Icons.person,
              isDarkMode: widget.isDarkMode,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Input Email
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              isDarkMode: widget.isDarkMode,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Input Password
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              isDarkMode: widget.isDarkMode,
              obscureText: true,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Input Alamat
            _buildTextField(
              controller: _alamatController,
              label: 'Alamat',
              icon: Icons.home,
              isDarkMode: widget.isDarkMode,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Input Telepon
            _buildTextField(
              controller: _teleponController,
              label: 'Telepon',
              icon: Icons.phone,
              isDarkMode: widget.isDarkMode,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Tombol Registrasi
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Tombol Kembali ke Login (opsional)
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      toggleTheme: widget.toggleTheme,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
              },
              child: Text('Kembali ke Login'),
            ),

            // Pesan Error atau Sukses
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color:
                      _message.contains('berhasil') ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    bool isDarkMode = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  final ImagePicker _picker = ImagePicker();

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

    final uri = Uri.parse('http://192.168.0.149/UASPWM/register.php');
    final request = http.MultipartRequest('POST', uri);

    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['nama'] = nama;
    request.fields['alamat'] = alamat;
    request.fields['telepon'] = telepon;

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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(
                toggleTheme: widget.toggleTheme,
                isDarkMode: widget.isDarkMode,
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
    final screenWidth = MediaQuery.of(context).size.width;

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
          // Konten registrasi
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
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
                _buildTextField(
                  controller: _namaController,
                  label: 'Nama',
                  icon: Icons.person,
                  isDarkMode: widget.isDarkMode,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  isDarkMode: widget.isDarkMode,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  isDarkMode: widget.isDarkMode,
                  obscureText: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _alamatController,
                  label: 'Alamat',
                  icon: Icons.home,
                  isDarkMode: widget.isDarkMode,
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildTextField(
                  controller: _teleponController,
                  label: 'Telepon',
                  icon: Icons.phone,
                  isDarkMode: widget.isDarkMode,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Register'),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                if (_message.isNotEmpty)
                  Text(
                    _message,
                    style: TextStyle(
                      color: _message.contains('berhasil')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
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

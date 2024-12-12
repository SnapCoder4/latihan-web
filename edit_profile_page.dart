import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final int userId;
  final String currentName;
  final String currentEmail;
  final String currentPhoto;

  EditProfilePage({
    required this.userId,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhoto,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _imageFile;

  bool _isLoading = false;
  String _message = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _emailController.text = widget.currentEmail;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Gagal memilih gambar: $e';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        _message = 'Nama dan email tidak boleh kosong.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    final uri = Uri.parse('http://192.168.1.2/lat_login/update_user_data.php');
    final request = http.MultipartRequest('POST', uri);

    request.fields['user_id'] = widget.userId.toString();
    request.fields['name'] = _nameController.text;
    request.fields['email'] = _emailController.text;

    if (_imageFile != null) {
      try {
        request.files.add(
          await http.MultipartFile.fromPath('photo', _imageFile!.path),
        );
      } catch (e) {
        setState(() {
          _message = 'Gagal menambahkan file: $e';
        });
      }
    }

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData.body);
        if (jsonResponse['value'] == 1) {
          Navigator.pop(context, {
            'name': _nameController.text,
            'email': _emailController.text,
            'photo': jsonResponse['photo_url'], // URL foto terbaru
          });
        } else {
          setState(() {
            _message = jsonResponse['message'];
          });
        }
      } else {
        setState(() {
          _message = 'Gagal memperbarui profil. Silakan coba lagi.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Kesalahan jaringan: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color:
                      _message.contains('berhasil') ? Colors.green : Colors.red,
                ),
              ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : widget.currentPhoto.isNotEmpty
                        ? NetworkImage(widget.currentPhoto) as ImageProvider
                        : null,
                child: _imageFile == null && widget.currentPhoto.isEmpty
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            TextButton(
              onPressed: _pickImage,
              child: Text('Pilih Foto'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

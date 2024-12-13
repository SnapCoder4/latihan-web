import 'cart_page.dart';
import 'settings_page.dart';
import 'RiwayatBelanjaPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart'; // Impor halaman login
import 'dart:convert'; // Untuk parsing JSON
import 'productdetailpage.dart'; // Impor halaman ProductDetailPage
import 'package:intl/intl.dart'; // Impor intl untuk memformat angka

class DashboardPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final int userId;

  DashboardPage({
    required this.toggleTheme,
    required this.isDarkMode,
    required this.userId,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List products = [];
  bool isLoading = true; // Menyimpan status loading
  String errorMessage = ''; // Menyimpan pesan error jika ada
  String userName = "Nama Pengguna";
  String userEmail = "email@domain.com";
  String userPhoto = ""; // URL foto pengguna

  Future<void> fetchUserData() async {
    final uri = Uri.parse(
        'http://192.168.0.149/UASPWM/get_user_data.php?user_id=${widget.userId}');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['value'] == 1) {
          setState(() {
            userName = data['nama'] ?? "Nama Pengguna";
            userEmail = data['email'] ?? "email@domain.com";
            userPhoto = data['foto'] ?? ""; // URL foto pengguna
          });
        } else {
          setState(() {
            errorMessage = data['message'];
          });
        }
      } else {
        print("Gagal mengambil data pengguna: ${response.body}");
      }
    } catch (e) {
      print("Kesalahan jaringan saat mengambil data pengguna: $e");
    }
  }

  // Fungsi untuk mengambil data produk dari API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.0.149/UASPWM/get_products.php'), // Ganti dengan URL API Anda
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading =
              false; // Set loading ke false setelah data berhasil diambil
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading ke false jika terjadi error
        errorMessage = e.toString(); // Simpan pesan error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchProducts();
  }

  // Fungsi untuk memformat harga
  String formatCurrency(String price) {
    final formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp ');
    return formatter.format(int.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Produk'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                radius: 80, // Ukuran lingkaran lebih besar
                backgroundImage: userPhoto.isNotEmpty
                    ? NetworkImage(userPhoto)
                    : null, // Gunakan NetworkImage jika URL tersedia
                child: userPhoto.isEmpty
                    ? Icon(Icons.person, size: 80)
                    : null, // Gunakan ikon default jika foto kosong
              ),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Keranjang Belanja'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(
                        userId:
                            widget.userId), // Menggunakan userId dari widget
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Riwayat Belanja'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiwayatBelanjaPage(
                        userId:
                            widget.userId), // Menggunakan userId dari widget
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                            toggleTheme: widget.toggleTheme,
                            isDarkMode: widget.isDarkMode,
                            userId: widget.userId,
                            currentName: userName,
                            currentEmail: userEmail,
                            currentPhoto: userPhoto)));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(
                            toggleTheme: widget.toggleTheme,
                            isDarkMode: widget.isDarkMode)));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Berbelanja',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(
                          child: Text(errorMessage)) // Menampilkan pesan error
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        product['image'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.error,
                                            size: 100,
                                            color: Colors.red,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['product'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          formatCurrency(product['price']),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailPage(
                                                  productName:
                                                      product['product'] ??
                                                          'Unknown Product',
                                                  productPrice: formatCurrency(
                                                      product['price'] ?? '0'),
                                                  productImage:
                                                      product['image'] ?? '',
                                                  productDescription:
                                                      product['description'] ??
                                                          'No description',
                                                  productId:
                                                      product['idproduct'] ??
                                                          '0',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text('Beli'),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                Size(double.infinity, 36),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
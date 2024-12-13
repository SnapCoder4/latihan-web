import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'settings_page.dart';
import 'cart_page.dart';
import 'RiwayatBelanjaPage.dart';
import 'productdetailpage.dart'; // Pastikan nama file sesuai dengan nama file sebenarnya

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
  bool isLoading = true;
  String errorMessage = '';
  String userName = "Nama Pengguna";
  String userEmail = "email@domain.com";
  String userPhoto = ""; // URL foto pengguna

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchProducts();
  }

  // Ambil data pengguna dari API
  Future<void> fetchUserData() async {
    final uri = Uri.parse(
        'http://192.168.1.2/lat_login/get_user_data.php?user_id=${widget.userId}');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userName = data['nama'] ?? "Nama Pengguna";
          userEmail = data['email'] ?? "email@domain.com";
          userPhoto = data['foto'] ?? ""; // URL foto pengguna
        });
      } else {
        print("Gagal mengambil data pengguna: ${response.body}");
      }
    } catch (e) {
      print("Kesalahan jaringan saat mengambil data pengguna: $e");
    }
  }

  // Ambil data produk dari API
  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.2/lat_login/get_products.php'),
      );

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat produk.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  // Update data profil setelah diedit
  Future<void> _handleProfileUpdated(dynamic updatedData) async {
    if (updatedData != null) {
      setState(() {
        userName = updatedData['name'] ?? userName;
        userEmail = updatedData['email'] ?? userEmail;
        userPhoto = updatedData['photo'] ?? userPhoto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout),
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
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                radius: 60, // Ukuran lingkaran lebih besar
                backgroundImage: userPhoto.isNotEmpty
                    ? NetworkImage(userPhoto)
                    : null, // Gunakan NetworkImage jika URL tersedia
                child: userPhoto.isEmpty
                    ? Icon(Icons.person, size: 60)
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
                    builder: (context) => CartPage(userId: widget.userId),
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
                    builder: (context) =>
                        RiwayatBelanjaPage(userId: widget.userId),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      toggleTheme: widget.toggleTheme,
                      isDarkMode: widget.isDarkMode,
                      userId: widget.userId,
                      currentName: userName,
                      currentEmail: userEmail,
                      currentPhoto: userPhoto,
                    ),
                  ),
                );
                await _handleProfileUpdated(updatedData);
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
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productName: product['product'] ?? "Produk",
                              productPrice: product['price'].toString(),
                              productImage: product['image'] ?? "",
                              productId: product['idproduct'] ?? "",
                              productDescription: product['description'] ??
                                  "Deskripsi tidak tersedia",
                              userId: widget.userId, // Pastikan userId dikirim
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                product['image'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            ),
                            Text(product['product'] ?? "Produk"),
                            Text("Rp ${product['price']}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

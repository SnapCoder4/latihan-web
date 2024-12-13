import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_page.dart';

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productId;
  final String productDescription;
  final int userId;

  // Constructor untuk menerima data dari halaman sebelumnya
  ProductDetailPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productId,
    required this.productDescription,
    required this.userId,
  });

  // Fungsi untuk menambahkan produk ke keranjang
  Future<void> _addToCart(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2/lat_login/add_to_cart.php'),
        body: {
          'user_id': userId.toString(),
          'idproduct': productId,
          'quantity': '1',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['value'] == 1) {
          // Berhasil menambahkan ke keranjang
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.green,
            ),
          );

          // Navigasi ke halaman keranjang
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(userId: userId),
            ),
          );
        } else {
          // Respons dari server gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Jika status HTTP bukan 200
        throw Exception('Gagal menambahkan ke keranjang.');
      }
    } catch (e) {
      // Tangani error jaringan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan ke keranjang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar produk
            Image.network(
              productImage,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),

            // Nama produk
            Text(
              productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Harga produk
            Text(
              'Rp $productPrice',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 20),

            // Deskripsi produk
            Text(
              productDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // Tombol Tambahkan ke Keranjang
            ElevatedButton(
              onPressed: () => _addToCart(context),
              child: Text('Tambahkan ke Keranjang'),
            ),
          ],
        ),
      ),
    );
  }
}

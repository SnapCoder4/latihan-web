import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_page.dart'; // Import file CartPage untuk navigasi

class ProductDetailPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;
  final String productId;
  final String productDescription; // Tambahkan parameter ini

  // Konstruktor
  ProductDetailPage({
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productId,
    required this.productDescription, // Tambahkan parameter ini
  });

  // Fungsi untuk menambahkan ke keranjang belanja
  Future<void> _addToCart(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2/lat_login/add_to_cart.php'),
        body: {
          'user_id': '1', // Ganti dengan user_id yang sesuai
          'idproduct': productId,
          'quantity': '1',
        },
      );

      final responseData = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseData['message']),
          backgroundColor: Colors.green,
        ),
      );

      // Navigasi ke halaman keranjang setelah berhasil menambahkan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CartPage(userId: 1), // Ganti userId sesuai login
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add product to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              productImage,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image, size: 100, color: Colors.red);
              },
            ),
            SizedBox(height: 20),
            Text(
              productName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Rp $productPrice',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text(
              productDescription,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RiwayatBelanjaPage extends StatefulWidget {
  final int userId; // User ID diteruskan saat navigasi
  RiwayatBelanjaPage({required this.userId});

  @override
  _RiwayatBelanjaPageState createState() => _RiwayatBelanjaPageState();
}

class _RiwayatBelanjaPageState extends State<RiwayatBelanjaPage> {
  List purchaseHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  // Fungsi untuk mengambil riwayat belanja
  Future<void> fetchPurchaseHistory() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.2/lat_login/get_riwayat_belanja.php?user_id=${widget.userId}',
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          purchaseHistory = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print('Error fetching data: ${response.body}');
        throw Exception('Failed to load purchase history');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPurchaseHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Belanja')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : purchaseHistory.isEmpty
                  ? Center(child: Text('Belum ada riwayat belanja.'))
                  : ListView.builder(
                      itemCount: purchaseHistory.length,
                      itemBuilder: (context, index) {
                        final item = purchaseHistory[index];
                        return ListTile(
                          leading: Image.network(
                            item['image'],
                            width: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error, color: Colors.red),
                          ),
                          title: Text(item['product']),
                          subtitle: Text('Rp ${item['price']}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tanggal: ${item['tgljual']}'),
                              Text('Qty: ${item['quantity']}'),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}

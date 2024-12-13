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
          'http://192.168.0.149/UASPWM/get_riwayat_belanja.php?user_id=${widget.userId}',
        ),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Check if the response is a list or a map with an error message
        if (responseData is List) {
          setState(() {
            purchaseHistory = responseData;
            isLoading = false;
          });
        } else if (responseData is Map && responseData.containsKey('message')) {
          setState(() {
            errorMessage = responseData['message'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected response format';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load purchase history';
          isLoading = false;
        });
      }
    } catch (e) {
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
      appBar: AppBar(
        title: Text('Riwayat Belanja'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
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

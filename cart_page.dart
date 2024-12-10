import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_item_model.dart';

class CartPage extends StatefulWidget {
  final int userId;
  CartPage({required this.userId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [];
  bool isLoading = true;
  int totalPrice = 0;

  Future<void> fetchCartItems() async {
    try {
      final response = await http.get(
        Uri.parse(
            '/lat_login/get_cart.php?user_id=${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          cartItems = data.map((item) => CartItem.fromJson(item)).toList();
          totalPrice = cartItems.fold(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateQuantity(String idproduct, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2/lat_login/update_cart_quantity.php'),
        body: {
          'user_id': widget.userId.toString(),
          'idproduct': idproduct,
          'quantity': quantity.toString(),
        },
      );

      if (response.statusCode == 200) {
        fetchCartItems(); // Refresh data setelah update
      }
    } catch (e) {
      print('Failed to update quantity: $e');
    }
  }

  Future<void> checkout() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2/lat_login/checkout.php'),
        body: {'user_id': widget.userId.toString()},
      );

      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );

      setState(() {
        cartItems.clear();
        totalPrice = 0;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Checkout failed: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Keranjang Belanja')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(item.image),
                        title: Text(item.productName),
                        subtitle: Text('Rp ${item.price} x ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  updateQuantity(
                                      item.idproduct, item.quantity - 1);
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                updateQuantity(
                                    item.idproduct, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Total: Rp $totalPrice',
                          style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: checkout,
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

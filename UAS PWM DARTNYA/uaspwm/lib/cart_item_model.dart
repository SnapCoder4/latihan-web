class CartItem {
  final String idproduct;
  final String productName;
  final String image;
  final int price;
  final int quantity;

  CartItem({
    required this.idproduct,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      idproduct: json['idproduct'],
      productName: json['product'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

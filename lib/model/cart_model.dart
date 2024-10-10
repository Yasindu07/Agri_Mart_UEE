class CartItem {
  final String productId;
  final String title;
  final double pricePerKg;
  final int quantity;
  final double totalPrice;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.title,
    required this.pricePerKg,
    required this.quantity,
    required this.totalPrice,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'pricePerKg': pricePerKg,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'imageUrl': imageUrl,
    };
  }

  // Add this method
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      title: map['title'],
      pricePerKg: map['pricePerKg'],
      quantity: map['quantity'],
      totalPrice: map['totalPrice'],
      imageUrl: map['imageUrl'],
    );
  }
}

class CartItem {
  final String productId;
  final String title;
  final double pricePerKg;
  final int quantity;
  final double totalPrice;
  final String imageUrl;
  final String farmerId;

  CartItem({
    required this.productId,
    required this.title,
    required this.pricePerKg,
    required this.quantity,
    required this.totalPrice,
    required this.imageUrl,
    required this.farmerId,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'pricePerKg': pricePerKg,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'imageUrl': imageUrl,
      'farmerId': farmerId,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'] ?? 'unknown', // Provide default value if null
      title: map['title'] ?? 'Unknown Product', // Default value if null
      pricePerKg: map['pricePerKg'] != null
          ? (map['pricePerKg'] as double)
          : 0.0, // Handle null for double
      quantity: map['quantity'] != null
          ? (map['quantity'] as int)
          : 1, // Handle null for int
      totalPrice: map['totalPrice'] != null
          ? (map['totalPrice'] as double)
          : 0.0, // Handle null for double
      imageUrl: map['imageUrl'] ??
          'https://via.placeholder.com/150', // Default image URL if null
      farmerId:
          map['farmerId'] ?? 'unknown', // Provide default farmer ID if null
    );
  }
}

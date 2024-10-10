class Order {
  final String userId;
  final List<Map<String, dynamic>> cartItems; // List of cart item maps
  final double totalAmount;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime orderDate;

  Order({
    required this.userId,
    required this.cartItems,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cartItems': cartItems,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  // You can also create a fromMap method if needed to retrieve orders from Firestore
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      userId: map['userId'],
      cartItems: List<Map<String, dynamic>>.from(map['cartItems']),
      totalAmount: map['totalAmount'],
      shippingAddress: map['shippingAddress'],
      paymentMethod: map['paymentMethod'],
      orderDate: DateTime.parse(map['orderDate']),
    );
  }
}

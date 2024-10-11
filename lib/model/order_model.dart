import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String userId;
  List<Map<String, dynamic>> cartItems;
  double totalAmount;
  String shippingAddress;
  String paymentMethod;
  String username;
  String phone;
  DateTime orderDate;

  OrderModel({
    required this.userId,
    required this.cartItems,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.username,
    required this.phone,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cartItems': cartItems,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'username': username,
      'phone': phone,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] ?? '',
      cartItems: List<Map<String, dynamic>>.from(map['cartItems']),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      shippingAddress: map['shippingAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      orderDate: map['orderDate'] is Timestamp
          ? (map['orderDate'] as Timestamp).toDate()
          : DateTime.parse(map['orderDate']),
    );
  }
}

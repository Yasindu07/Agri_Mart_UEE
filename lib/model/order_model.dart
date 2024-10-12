import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String userId;
  List<Map<String, dynamic>> cartItems;
  double totalAmount;
  String shippingAddress;
  String paymentMethod;
  String username;
  String phone;
  bool isChecked = false;
  bool isCompleted = false;
  bool isArrived = false;
  bool isStarted = false;
  DateTime orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.cartItems,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.username,
    required this.phone,
    required this.isChecked,
    required this.isCompleted,
    required this.isArrived,
    required this.isStarted,
    required this.orderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'cartItems': cartItems,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'username': username,
      'phone': phone,
      'isChecked': isChecked,
      'isCompleted': isCompleted,
      'isArrived': isArrived,
      'isStarted': isStarted,
      'orderDate': Timestamp.fromDate(orderDate),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      cartItems: List<Map<String, dynamic>>.from(map['cartItems']),
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      shippingAddress: map['shippingAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      username: map['username'] ?? '',
      phone: map['phone'] ?? '',
      isChecked: map['isChecked'] ?? false,
      isCompleted: map['isCompleted'] ?? false,
      isArrived: map['isArrived'] ?? false,
      isStarted: map['isStarted'] ?? false,
      orderDate: map['orderDate'] is Timestamp
          ? (map['orderDate'] as Timestamp).toDate()
          : DateTime.parse(map['orderDate']),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_mart/model/order_model.dart' as custom_order;

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to submit the order to Firestore
  Future<void> submitOrder(custom_order.Order order) async {
    try {
      // Save order to Firestore
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      throw Exception('Failed to place order: $e');
    }
  }
}

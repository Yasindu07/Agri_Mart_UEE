import 'package:agro_mart/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new order
  Future<void> addOrder(OrderModel order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
      print('Order added successfully');
    } catch (e) {
      throw Exception('Failed to add order: $e');
    }
  }

  // Retrieve a specific order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('orders').doc(orderId).get();
      if (docSnapshot.exists) {
        return OrderModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('No such order found');
        return null;
      }
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  // Update an existing order
  Future<void> updateOrder(String orderId, OrderModel updatedOrder) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update(updatedOrder.toMap());
      print('Order updated successfully');
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  // Delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
      print('Order deleted successfully');
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  Stream<List<OrderModel>> getAllOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) =>
        snapshot
            .docs
            .map(
                (doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}

import 'package:agro_mart/model/order_model.dart';
import 'package:agro_mart/model/user_model.dart';
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

  // Stream to get all orders with user information
  Stream<List<Map<String, dynamic>>> getAllOrdersWithUserData() {
    return _firestore
        .collection('orders')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> orderList = [];

      try {
        for (var doc in snapshot.docs) {
          final orderData = doc.data();
          print('Order raw data: $orderData');

          if (orderData['userId'] is! String) {
            throw Exception(
                'Invalid userId type, expected String but found ${orderData['userId'].runtimeType}');
          }

          OrderModel order = OrderModel.fromMap(orderData);
          orderList.add({
            'order': order,
          });
        }
      } catch (e) {
        print('Error fetching orders with user data: $e');
        throw Exception('Error fetching orders');
      }

      return orderList;
    });
  }
}

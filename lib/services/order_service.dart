import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_mart/model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');

  // Add a new order
  Future<void> addOrder(OrderModel order) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('orders').add(order.toMap());
      await docRef.update({
        'OrderId': docRef.id
      }); // Update the document to include the generated ID
      print('Order added successfully with ID: ${docRef.id}');
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

  // Update order status for a specific order
  Future<void> updateOrderStatus(String orderId) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'isStarted': true});
      print('Order status updated successfully for order ID: $orderId');
    } catch (e) {
      throw Exception('Failed to update order status: $e');
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

  Stream<List<OrderModel>> getOrdersByFarmer(String farmerId) {
    return _firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.data() as Map<String, dynamic>))
          .where((order) => order.cartItems.any((item) =>
              item['farmerId'] == farmerId)) // Filtering based on farmerId
          .toList();
    });
  }
}

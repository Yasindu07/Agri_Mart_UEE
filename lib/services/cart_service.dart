import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_mart/model/cart_model.dart';

class CartService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add item to cart
  Future<void> addToCart(CartItem cartItem) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      await _firestore
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(cartItem.productId)
          .set(cartItem.toMap());
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  // Update item in cart
  Future<void> updateCartItem(
      String productId, int quantity, double totalPrice) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      await _firestore
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(productId)
          .update({
        'quantity': quantity,
        'totalPrice': totalPrice,
      });
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  // Delete item from cart
  Future<void> deleteCartItem(String productId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      await _firestore
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete cart item: $e');
    }
  }

  // Get all items from cart
  Future<List<CartItem>> getCartItems() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .get();

      return snapshot.docs.map((doc) {
        return CartItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to retrieve cart items: $e');
    }
  }
}

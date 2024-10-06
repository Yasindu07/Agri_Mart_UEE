import 'package:agro_mart/model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a New Product
  Future<void> addProduct(Product product) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Add the user ID to the product before saving
      final productWithUserId = Product(
        id: product.id, // Ensure the ID is properly used
        title: product.title,
        category: product.category,
        quantity: product.quantity,
        description: product.description,
        location: product.location,
        pricePerKg: product.pricePerKg,
        imageUrls: product.imageUrls,
        userId: user.uid, // Add the logged-in user's ID
      );

      // Use .doc(id).set(...) instead of .add(...)
      await _firestore
          .collection('products')
          .doc(productWithUserId.id) // Use product's id
          .set(productWithUserId.toMap());
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Read a List of Products for the current user
  Stream<List<Product>> getUserProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.error('User not logged in');
    }

    return _firestore
        .collection('products')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Read a List of All Products
  Stream<List<Product>> getAllProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toMap());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}

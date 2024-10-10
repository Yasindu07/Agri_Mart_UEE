

import 'package:agro_mart/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register with email, password, name, address, and phone number
  Future<User?> registerWithEmailAndPassword(
      String email,  String password, ) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      // Store additional user information in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'role': 'user', // You can customize roles as needed
        'email': userCredential.user!.email,
       
      });
      return userCredential.user;
    } catch (e) {
      print('Registration error: ${e.toString()}');
      return null;
    }
  }


  // Add user details method
  Future<void> addUserDetails(UserModel userModel) async {
    try {
      // Ensure the UID is set in the UserModel
      if (userModel.uid == null) {
        throw Exception("User UID is required");
      }

      // Set user details in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.uid) // Use uid from UserModel
          .set(userModel.toMap(),
              SetOptions(merge: true)); // Merge to prevent overwriting
    } catch (e) {
      print('Error adding user details: ${e.toString()}');
    }
  }

  //Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sing Out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

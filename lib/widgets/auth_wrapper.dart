import 'package:agro_mart/screens/admin_screen.dart';
import 'package:agro_mart/screens/farmer/farmer_screen.dart';
import 'package:agro_mart/screens/signup_screen.dart';
import 'package:agro_mart/screens/transpoter/formOrHome.dart';
import 'package:agro_mart/screens/buyer/user_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          // If no user is logged in, navigate to the signup screen
          if (user == null) {
            return SignupScreen();
          } else {
            // If a user is logged in, fetch their role
            return FutureBuilder<String>(
              future: getUserRole(user),
              builder: (context, snapshot) {
                // Check if the Future has completed
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    switch (snapshot.data) {
                      case 'admin':
                        return AdminScreen();
                      case 'farmer':
                        return FarmerScreen();
                      case 'transporter':
                        return FormOrHome();
                      case 'user':
                        return UserScreen();
                      default:
                        return Scaffold(
                          body: Center(
                            child: Text('Invalid user role'),
                          ),
                        );
                    }
                  } else {
                    return Scaffold(
                      body: Center(
                        child: Text('Failed to load user role'),
                      ),
                    );
                  }
                } else {
                  // Show loading spinner while fetching the user role
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
        } else {
          // Show loading spinner while waiting for auth state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<String> getUserRole(User user) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        return doc['role'] ??
            'user'; // Return 'user' as default role if no role is found
      } else {
        // Handle the case where the document does not exist or has no data
        throw 'User document does not exist';
      }
    } catch (e) {
      // Handle errors such as network issues
      print('Error fetching user role: $e');
      throw 'Error fetching user role';
    }
  }
}

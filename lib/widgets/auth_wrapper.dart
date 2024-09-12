import 'package:agro_mart/screens/admin_screen.dart';
import 'package:agro_mart/screens/farmer_screen.dart';
import 'package:agro_mart/screens/signup_screen.dart';
import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/screens/user_Screen.dart';
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
          if (user == null) {
            return SignupScreen();
          } else {
            return FutureBuilder<String>(
              future: getUserRole(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  switch (snapshot.data) {
                    case 'admin':
                      return AdminScreen();
                    case 'farmer':
                      return FarmerScreen();
                    case 'transporter':
                      return TransporterScreen();
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
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            );
          }
        } else {
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
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return doc['role'] ?? 'user';
  }
}

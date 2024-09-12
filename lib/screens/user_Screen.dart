import 'package:agro_mart/screens/login_screen.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Welcome, User!"),
          ),
          SizedBox(
              height: 20), // Adds some space between the text and the button
          ElevatedButton(
            onPressed: () {
              // Add the functionality for the button here
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Button Pressed"),
                    content: Text("You pressed the button!"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Press Me"), // Button label
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}

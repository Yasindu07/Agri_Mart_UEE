import 'package:agro_mart/forgot_password/varify_mail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importing fluttertoast

class ForgetEmailscreen extends StatefulWidget {
  const ForgetEmailscreen({super.key});

  @override
  State<ForgetEmailscreen> createState() => _ForgetEmailscreenState();
}

class _ForgetEmailscreenState extends State<ForgetEmailscreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Email format validation using RegExp
  bool _isEmailValid(String email) {
    final emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // Basic email format regex
    return emailRegExp.hasMatch(email);
  }

  // Reset password
  Future passwordReset() async {
    String email = _emailController.text.trim();

    // Check if email format is valid
    if (!_isEmailValid(email)) {
      Fluttertoast.showToast(
        msg: "Invalid email format. Please re-enter a valid email.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      // Check if the user exists in Firestore before sending the reset email
      var users = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (users.docs.isEmpty) {
        // User does not exist in Firestore
        Fluttertoast.showToast(
          msg: "No user found with this email. Please recheck and try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Send the password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        Fluttertoast.showToast(
          msg: "Check your email and Reset Password.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VarifyMail(
                      email: email,
                    )));
      }
    } catch (e) {
      // Print error to see what went wrong
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    double padding = screenWidth * 0.05;
    double buttonHeight = screenHeight * 0.07;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Forgot Password',
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.03),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Enter your email and we will send you a link to reset your password',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.050,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: screenWidth * 0.055,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  await passwordReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF28A745),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Send',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:agro_mart/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VarifyMail extends StatefulWidget {
  final String email;

  const VarifyMail({Key? key, required this.email}) : super(key: key);

  @override
  State<VarifyMail> createState() => _VarifyMailState();
}

class _VarifyMailState extends State<VarifyMail> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    double buttonHeight = screenHeight * 0.07;
    double imageHeight = screenHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Widget
            Image.asset(
              'assets/resetPw.jpg',
              height: imageHeight,
              fit: BoxFit.cover,
            ),

            SizedBox(height: screenHeight * 0.05),
            Text(
              'Password Reset Email Sent',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              widget.email,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Your Account Security is Our Priority We have sent You a Secure Link to Safely Change Your Password And Keep Your Account Protected',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.05),
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            TextButton(
                onPressed: () {
                  // Resend Email
                },
                child: Text(
                  'Resend Email',
                  style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.green),
                )),
          ],
        ),
      ),
    );
  }
}

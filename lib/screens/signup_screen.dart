import 'package:agro_mart/screens/login_screen.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthServices _auth = AuthServices();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // For confirm password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          var screenHeight = constraints.maxHeight;
          var screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome!',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.10,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: screenWidth * 0.13,
                            backgroundColor:
                                const Color.fromARGB(255, 116, 116, 116),
                            child: Icon(
                              Icons.person,
                              size: screenWidth * 0.13,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: screenWidth * 0.04,
                              backgroundColor: const Color(0xFF28A745),
                              child: Icon(
                                Icons.add,
                                size: screenWidth * 0.07,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Sign up',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Name Field
                  buildTextField('Name', Icons.person, _nameController),
                  SizedBox(height: screenHeight * 0.02),
                  // Email Field
                  buildTextField('Email', Icons.email, _emailController),
                  SizedBox(height: screenHeight * 0.02),
                  // Address Field
                  buildTextField(
                      'Address', Icons.location_on, _addressController),
                  SizedBox(height: screenHeight * 0.02),
                  // Phone Field
                  buildTextField('Phone No', Icons.phone, _phoneController),
                  SizedBox(height: screenHeight * 0.02),
                  // Password Field
                  buildPasswordField('Password', _passwordController),
                  SizedBox(height: screenHeight * 0.02),
                  // Confirm Password Field
                  buildPasswordField(
                      'Confirm password', _confirmPasswordController),
                  SizedBox(height: screenHeight * 0.05),
                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28A745),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;

                        if (password != confirmPassword) {
                          Fluttertoast.showToast(
                            msg: "Passwords do not match",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color.fromARGB(255, 238, 118, 102),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        User? user = await _auth.registerWithEmailAndPassword(
                          _emailController.text,
                          password,
                        );

                        if (user != null) {
                          Fluttertoast.showToast(
                            msg:
                                "Account created successfully. Now you can login!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color(0xFF56dc6e),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Failed to create account",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Color.fromARGB(255, 238, 118, 102),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.045,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have an account? ",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.025),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF28A745),
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Text Field Builder with controller
Widget buildTextField(
    String hintText, IconData icon, TextEditingController controller) {
  return TextField(
    controller: controller, // Use the controller here
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Color(0xFF28A745),
      ),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        //borderSide: BorderSide(color: Colors.grey, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey, // Border color when enabled
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.green, // Border color when focused
          width: 2.0,
        ),
      ),
    ),
  );
}

// Password Field Builder with controller
Widget buildPasswordField(String hintText, TextEditingController controller) {
  bool isObscure = true;
  return StatefulBuilder(
    builder: (context, setState) {
      return TextField(
        controller: controller, // Use the controller here
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color(0xFF28A745)),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF28A745),
            ),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            //borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey, // Border color when enabled
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green, // Border color when focused
              width: 2.0,
            ),
          ),
        ),
      );
    },
  );
}

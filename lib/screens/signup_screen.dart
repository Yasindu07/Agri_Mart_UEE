import 'package:agro_mart/screens/login_screen.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isSuccess = false;
  bool isLoading = false;

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
              child: Form(
                key: _formkey,
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
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: screenWidth * 0.04,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: Icon(
                                  Icons.add,
                                  size: screenWidth * 0.07,
                                  color: Theme.of(context).colorScheme.surface,
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
                    buildTextField('Name', Icons.person, _nameController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    // Email Field
                    buildTextField('Email', Icons.email, _emailController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    // Address Field
                    buildTextField(
                        'Address', Icons.location_on, _addressController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Address is required';
                      }
                      return null;
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    // Phone Field
                    buildTextField('Phone No', Icons.phone, _phoneController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    }),
                    SizedBox(height: screenHeight * 0.02),
                    // Password Field
                    buildPasswordField('Password', _passwordController),
                    SizedBox(height: screenHeight * 0.015),
                    SizedBox(
                      height: screenHeight *
                          0.109, // Reduce the height to remove extra space
                      child: FlutterPwValidator(
                        defaultColor: Colors.grey,
                        uppercaseCharCount: 1,
                        minLength: 8,
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.05, // Decrease height here
                        onSuccess: () {
                          setState(() {
                            isSuccess = true;
                          });
                        },
                        onFail: () {
                          isSuccess = false;
                        },
                        controller: _passwordController,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    // Confirm Password Field
                    buildPasswordField(
                        'Confirm password', _confirmPasswordController,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm password is required';
                      }
                      if (value != _passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    }),
                    SizedBox(height: screenHeight * 0.05),
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.072,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            User? user =
                                await _auth.registerWithEmailAndPassword(
                                    _emailController.text,
                                    _passwordController.text);

                            setState(() {
                              isLoading = false;
                            });

                            if (user != null) {
                              Fluttertoast.showToast(
                                msg:
                                    "Account created successfully. Now you can login!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                textColor:
                                    Theme.of(context).colorScheme.surface,
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSecondary,
                                textColor:
                                    Theme.of(context).colorScheme.surface,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Loading...',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.05,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  CircularProgressIndicator(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    strokeWidth: screenWidth * 0.013,
                                  ),
                                ],
                              )
                            : Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.05,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w600,
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
                                fontSize: screenWidth * 0.045),
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
                                color: Theme.of(context).colorScheme.primary,
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
            ),
          );
        },
      ),
    );
  }
}

// Text Field Builder with controller
Widget buildTextField(
    String hintText, IconData icon, TextEditingController controller,
    {String? Function(String?)? validator}) {
  return TextFormField(
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
    validator: validator,
  );
}

// Password Field Builder with controller
Widget buildPasswordField(String hintText, TextEditingController controller,
    {String? Function(String?)? validator}) {
  bool isObscure = true;

  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        // Use TextFormField instead of TextField
        controller: controller,
        obscureText: isObscure, // Toggle password visibility
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: Color(0xFF28A745)),
          suffixIcon: IconButton(
            icon: Icon(
              isObscure ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF28A745),
            ),
            onPressed: () {
              setState(() {
                isObscure = !isObscure; // Toggle the obscure text state
              });
            },
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
        validator: validator, // Validation logic
      );
    },
  );
}

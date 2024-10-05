import 'package:agro_mart/forgot_password/forget_pw_email.dart';
import 'package:agro_mart/screens/signup_screen.dart';
import 'package:agro_mart/services/auth_services.dart';
import 'package:agro_mart/widgets/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthServices _auth = AuthServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isLoading = false;

  // Email Validator
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password Validator
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06, // Responsive horizontal padding
            vertical: screenHeight * 0.06, // Responsive vertical padding
          ),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.1), // Responsive spacing
                Text(
                  'Welcome \nback!',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.13, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Sign in to continue',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.065, // Responsive font size
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email,
                        color: Theme.of(context).colorScheme.primary),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: _emailValidator, // Email validation
                ),
                SizedBox(height: screenHeight * 0.03),
                // Password Field
                buildPasswordField(
                  'Password',
                  _passwordController,
                  _passwordValidator, // Pass the password validator here
                ),
                // Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to the forget password screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgetEmailscreen()));
                    },
                    child: Text(
                      'Forget Password?',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF2C87FF),
                        fontSize: screenWidth * 0.04, // Responsive font size
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.07, // Responsive button height
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate the form before proceeding
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        User? user = await _auth.signInWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        if (user != null) {
                          Fluttertoast.showToast(
                            msg: "Logged In Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            textColor: Theme.of(context).colorScheme.surface,
                            fontSize: 16,
                          );
                          // Navigate to the home screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthWrapper()),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Invalid Email or Password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            textColor: Theme.of(context).colorScheme.surface,
                            fontSize: 16,
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // Custom green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
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
                                color: Theme.of(context).colorScheme.secondary,
                                strokeWidth: screenWidth * 0.013,
                              ),
                            ],
                          )
                        : Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.05,
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.04, // Responsive font size
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                screenWidth * 0.045, // Responsive font size
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
      ),
    );
  }
}

class ForgetEmailScreen {}

// Password Field with Validation
Widget buildPasswordField(String hintText, TextEditingController controller,
    String? Function(String?) validator) {
  bool isObscure = true;
  return StatefulBuilder(
    builder: (context, setState) {
      return TextFormField(
        controller: controller,
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
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.green,
              width: 2.0,
            ),
          ),
        ),
        validator: validator, // Use the passed validator
      );
    },
  );
}

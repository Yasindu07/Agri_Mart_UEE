import 'package:agro_mart/screens/transporter_screen.dart';
import 'package:agro_mart/services/transporter_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class TransporterFormPage extends StatefulWidget {
  @override
  _TransporterFormPageState createState() => _TransporterFormPageState();
}

class _TransporterFormPageState extends State<TransporterFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  // final TextEditingController _licenseImageController = TextEditingController();
  // final TextEditingController _insuranceImageController =
  //     TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  final TransporterService _transporterService = TransporterService();
  bool _isLoading = false;
  // bool _isTransporter = false;
  File? _licenseImage; // To store picked license image
  File? _insuranceImage; // To store picked insurance image
  String? _licenseImageUrl; // To store license image URL after upload
  String? _insuranceImageUrl; // To store insurance image URL after upload

  final ImagePicker _picker = ImagePicker();

  // Clean up controllers when the widget is disposed
  @override
  void dispose() {
    _licensePlateController.dispose();
    _licenseNumberController.dispose();
    // _licenseImageController.dispose();
    // _insuranceImageController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  } // Variable to track if user is a transporter

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchUserRole();
  // }

  // // Function to fetch user role from Firestore
  // Future<void> _fetchUserRole() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Fetch user document from Firestore
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       // Check if the user is a transporter based on their role
  //       setState(() {
  //         _isTransporter = userDoc['role'] == 'transporter';
  //       });
  //     }
  //   }
  // }

  // Function to submit transporter details
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_licenseImage == null || _insuranceImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please upload both License and Insurance images')),
        );
        return;
      }
      // Start loading
      setState(() {
        _isLoading = true;
      });

      try {
        _licenseImageUrl =
            await _uploadImageToStorage(_licenseImage!, 'licenseImage');
        _insuranceImageUrl =
            await _uploadImageToStorage(_insuranceImage!, 'insuranceImage');
        // Add transporter details
        await _transporterService.addTranspoterDetails(
          _transporterService.user!.uid,
          _licensePlateController.text.trim(),
          _licenseNumberController.text.trim(),
          // _licenseImageController.text.trim(),
          // _insuranceImageController.text.trim(),
          _licenseImageUrl!,
          _insuranceImageUrl!,
          _bankNameController.text.trim(),
          _accountNumberController.text.trim(),
        );

        // On success, navigate to home or show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Transporter details submitted successfully!')),
        );

        // Optional: Navigate to another page like the home screen
        // Navigator.of(context).pushReplacementNamed('/transporterHome');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => TransporterScreen()));
      } catch (e) {
        // On error, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        // Stop loading
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to pick image
  Future<void> _pickImage(ImageSource source, bool isLicenseImage) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isLicenseImage) {
          _licenseImage = File(pickedFile.path);
        } else {
          _insuranceImage = File(pickedFile.path);
        }
      });
    }
  }

  // Function to upload image to Firebase Storage
  Future<String> _uploadImageToStorage(
      File imageFile, String folderName) async {
    final storageRef = FirebaseStorage.instance.ref().child(
        'transporter_images/$folderName/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Join our network of trusted transporters and start earning today!",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Only show the form if the user is a transporter

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInputField(
                    controller: _licensePlateController,
                    label: "Vehicle License Plate",
                    icon: Icons.directions_car,
                  ),
                  _buildInputField(
                    controller: _licenseNumberController,
                    label: "License Number",
                    icon: Icons.card_membership,
                  ),
                  _buildUploadField("Upload License Image", true),
                  _buildUploadField("Vehicle Insurance", false),
                  _buildInputField(
                    controller: _bankNameController,
                    label: "Bank Name",
                    icon: Icons.account_balance,
                  ),
                  _buildInputField(
                    controller: _accountNumberController,
                    label: "Bank Account Number",
                    icon: Icons.account_box,
                  ),
                  const SizedBox(height: 16),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  // Upload Field Widget
  // Upload Field Widget
  Widget _buildUploadField(String label, bool isLicenseImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label),
              ),
              IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.green),
                onPressed: () => _pickImage(ImageSource.camera, isLicenseImage),
              ),
              IconButton(
                icon: Icon(Icons.image, color: Colors.green),
                onPressed: () =>
                    _pickImage(ImageSource.gallery, isLicenseImage),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Display the image once it's picked
          if (isLicenseImage && _licenseImage != null)
            Image.file(_licenseImage!,
                height: 100, width: 100, fit: BoxFit.cover),
          if (!isLicenseImage && _insuranceImage != null)
            Image.file(_insuranceImage!,
                height: 100, width: 100, fit: BoxFit.cover),
        ],
      ),
    );
  }
}

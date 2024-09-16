import 'package:agro_mart/services/location_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class FarmerProductAdd extends StatefulWidget {
  const FarmerProductAdd({super.key});

  @override
  State<FarmerProductAdd> createState() => _FarmerProductAddState();
}

class _FarmerProductAddState extends State<FarmerProductAdd> {
  final List<File?> _images = List<File?>.filled(4, null);
  final ImagePicker _picker = ImagePicker();

  final LocationService _locationService = LocationService();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        int index = _images.indexWhere((image) => image == null);
        if (index != -1) {
          _images[index] = File(pickedFile.path);
        }
      });
    }
  }

  // Function to capture an image from the camera
  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        int index = _images.indexWhere((image) => image == null);
        if (index != -1) {
          _images[index] = File(pickedFile.path);
        }
      });
    }
  }

  // Function to remove image
  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  // Method to fetch current location and update the location text field
  Future<void> _setCurrentLocation() async {
    try {
      Position? position = await _locationService.getCurrentLocation();
      if (position != null) {
        String address = await _locationService.getAddressFromLatLng(position);
        setState(() {
          _locationController.text =
              address; // Set the fetched address to the text field
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Product',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'step 1/2',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              // Camera and Gallery Icon Row
              Row(
                children: [
                  Text(
                    'Upload Image',
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.camera_alt, size: screenWidth * 0.08),
                    onPressed: _captureImage, // Capture image
                    tooltip: 'Capture Image',
                  ),
                  IconButton(
                    icon: Icon(Icons.photo, size: screenWidth * 0.08),
                    onPressed: _pickImage, // Pick image from gallery
                    tooltip: 'Pick Image from Gallery',
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              // Display Selected Images in a Scrollable Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    4,
                    (index) => _images[index] != null
                        ? Stack(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(right: screenWidth * 0.03),
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                    image: FileImage(_images[index]!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color:
                                        const Color.fromARGB(255, 218, 59, 59),
                                    size: screenWidth * 0.05,
                                  ),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.only(right: screenWidth * 0.03),
                            width: screenWidth * 0.2,
                            height: screenWidth * 0.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Icon(Icons.image,
                                size: screenWidth * 0.1, color: Colors.grey),
                          ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Enter Title
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  counterText: "0/50",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
                maxLength: 50,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Select Category
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
                items: ['Vegetable', 'Fruits', 'Seeds', 'Dry Foods']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category,
                              style: TextStyle(fontSize: screenWidth * 0.04)),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: screenHeight * 0.02),
              // Quantity and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, color: Colors.black),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Kg',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, color: Colors.black),
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Enter Description
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  counterText: "0/200",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
                maxLength: 200,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Items Location automatically set from current location
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Items Location',
                  prefixIcon: Icon(Icons.location_on,
                      size: screenWidth * 0.06, color: Colors.green),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Price Per 1 Kg and Currency
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Price Per 1 Kg',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, color: Colors.black),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'RS',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04, color: Colors.black),
                      ),
                      enabled: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              // Next Button
              Center(
                child: SizedBox(
                  width: screenWidth * 0.25,
                  height: screenHeight * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      // Button action here
                    },
                    child: Text(
                      'Next',
                      style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

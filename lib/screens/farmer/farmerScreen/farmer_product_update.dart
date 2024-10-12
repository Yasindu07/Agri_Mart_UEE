import 'package:agro_mart/model/product_model.dart';
import 'package:agro_mart/screens/farmer/farmerScreen/farmer_helper/image_helper.dart';
import 'package:agro_mart/screens/farmer/farmer_screen.dart';
import 'package:agro_mart/services/location_service.dart';
import 'package:agro_mart/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:developer' as devtools;

class FarmerProductUpdate extends StatefulWidget {
  final Product product;
  const FarmerProductUpdate({required this.product});

  @override
  State<FarmerProductUpdate> createState() => _FarmerProductUpdateState();
}

class _FarmerProductUpdateState extends State<FarmerProductUpdate> {
  final ProductService _productService = ProductService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _categoryController;

  final ImageService _imageService = ImageService();

  final List<File?> _images = List<File?>.filled(4, null);
  final LocationService _locationService = LocationService();

  final TextEditingController _locationController = TextEditingController();

  int _titleLength = 0;
  int _descLength = 0;

  bool isLoading = false;

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    // Initialize controllers first
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.pricePerKg.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _categoryController = TextEditingController(text: widget.product.category);

    // Then add listeners
    _titleController.addListener(() {
      setState(() {
        _titleLength = _titleController.text.length;
      });
    });

    _descriptionController.addListener(() {
      setState(() {
        _descLength = _descriptionController.text.length;
      });
    });

    // Set the current location
    _setCurrentLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Upload all images at once and get the list of image URLs
    List<String> imageUrls = await _imageService.uploadImages(_images);

    Product product = Product(
      id: widget.product.id,
      title: _titleController.text,
      category: _selectedCategory!,
      quantity: double.parse(_quantityController.text),
      description: _descriptionController.text,
      location: _locationController.text,
      pricePerKg: double.parse(_priceController.text),
      imageUrls: imageUrls,
      userId: widget.product.userId,
    );

    try {
      await _productService.updateProduct(product);
      Fluttertoast.showToast(
        msg: "Product Updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FarmerScreen(
                  initialIndex: 0,
                )),
      );
    } catch (e) {
      devtools.log('Error adding product: $e');
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to pick an image from the gallery using ImageService
  Future<void> _pickImage() async {
    final image = await _imageService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        int index = _images.indexWhere((image) => image == null);
        if (index != -1) {
          _images[index] = image;
        }
      });
    }
  }

  // Function to capture an image from the camera using ImageService
  Future<void> _captureImage() async {
    final image = await _imageService.captureImageFromCamera();
    if (image != null) {
      setState(() {
        int index = _images.indexWhere((image) => image == null);
        if (index != -1) {
          _images[index] = image;
        }
      });
    }
  }

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
      devtools.log('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Update Product',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => FarmerScreen(initialIndex: 0))),
        ),
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
                controller: _titleController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Enter Title',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  counterText: '$_titleLength/50',
                  counterStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: Theme.of(context).colorScheme.primary),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Select Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) => setState(() => _selectedCategory = value),
                items: ['Vegetable', 'Fruits', 'Seeds', 'Dry Foods']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Select Category'),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Quantity and Unit
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
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
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
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
                controller: _descriptionController,
                maxLength: 200,
                minLines: 4,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Enter Description',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  counterText: '$_descLength/200',
                  counterStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: Theme.of(context).colorScheme.primary),
                  labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04, color: Colors.black),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Items Location automatically set from current location
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Items Location',
                  prefixIcon: Icon(Icons.location_on,
                      size: screenWidth * 0.06,
                      color: Theme.of(context).colorScheme.primary),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
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
                      controller: _priceController,
                      decoration: InputDecoration(
                        labelText: 'Price Per 1 Kg',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
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
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.40,
                      height: screenHeight * 0.055,
                      child: ElevatedButton(
                        onPressed: () => _updateProduct(),
                        child: isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'updating...',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                    width: screenHeight * 0.03,
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      strokeWidth: screenWidth * 0.010,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Update',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

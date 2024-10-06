import 'package:flutter/material.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final TextEditingController _homeStreetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(); // Restored Phone Number field
  final TextEditingController _specialNoteController =
      TextEditingController(); // Restored Special Note field

  String? _selectedDistrict;
  bool _setAsDefault = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your Location'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back action
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.home, // Home icon
                    size: 34.0, // You can adjust the size as needed
                    color: Color.fromARGB(255, 5, 167, 13),
                  ),
                  const SizedBox(width: 8.0), //space between icon and text
                  const Text(
                    'Add Your Primary Location',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 69, 5),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              // Green background form section starts here
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50), // Green background color
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Home Street', _homeStreetController),
                    const SizedBox(height: 16.0),
                    _buildTextField('Enter City', _cityController),
                    const SizedBox(height: 16.0),
                    _buildDropDown('Enter District'),
                    const SizedBox(height: 16.0),
                    _buildSpecialNoteField(), // Restored Special Note field
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('Phone Number',
                              _phoneNumberController), // Restored Phone Number field
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child:
                              _buildTextField('Zip Code', _zipCodeController),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Green background form section ends here
              const SizedBox(height: 16.0),
              _buildDefaultAddressSwitch(),
              const SizedBox(height: 16.0), // Replaced Spacer with SizedBox
              _buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true, // Ensures the background is filled
        fillColor: Colors.white, // Sets the background color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 25.0, horizontal: 15.0), // Increases the height
      ),
    );
  }

  Widget _buildDropDown(String hint) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true, // Ensures the background is filled
        fillColor: Colors.white, // Sets the background color to white
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
      ),
      hint: Text(hint),
      items: <String>[
        'Colombo',
        'Gampaha',
        'Kalutara',
        'Kandy',
        'Matale',
        'Nuwara Eliya',
        'Galle',
        'Matara',
        'Hambantota',
        'Jaffna',
        'Kilinochchi',
        'Mannar',
        'Vavuniya',
        'Mullaitivu',
        'Trincomalee',
        'Batticaloa',
        'Ampara',
        'Kurunegala',
        'Puttalam',
        'Anuradhapura',
        'Polonnaruwa',
        'Badulla',
        'Monaragala',
        'Ratnapura',
        'Kegalle'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle change
        setState(() {
          _selectedDistrict = newValue;
        });
      },
    );
  }

  Widget _buildSpecialNoteField() {
    return TextField(
      controller: _specialNoteController,
      maxLength: 200,
      decoration: InputDecoration(
        filled: true, // Ensures the background is filled
        fillColor: Colors.white, // Sets the background color to white
        hintText: 'Enter Special Note (Optional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 55.0, horizontal: 15.0),
        counterText: '${_specialNoteController.text.length}/200',
      ),
    );
  }

  Widget _buildDefaultAddressSwitch() {
    return SwitchListTile(
      title: const Text('Set as default shipping address'),
      value: _setAsDefault,
      onChanged: (bool value) {
        setState(() {
          _setAsDefault = value;
        });
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          Map<String, String> locationData = {
            'street': _homeStreetController.text,
            'city': _cityController.text,
            'district': _selectedDistrict ?? 'Unknown',
            'zipCode': _zipCodeController.text,
            'phoneNumber': _phoneNumberController.text,
            'specialNote': _specialNoteController.text,
          };

          // Pass the location data back to the previous page (ProfilePage)
          Navigator.pop(context, locationData);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: const Text(
          'Add',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

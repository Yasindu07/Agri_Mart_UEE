import 'package:flutter/material.dart';

class AddLocationPage extends StatelessWidget {
  const AddLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your Location'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back action
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Handle profile action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Your Primary Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            _buildTextField('Home Street'),
            SizedBox(height: 16.0),
            _buildTextField('Enter City'),
            SizedBox(height: 16.0),
            _buildDropDown('Enter District'),
            SizedBox(height: 16.0),
            _buildSpecialNoteField(),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(child: _buildTextField('Phone Number')),
                SizedBox(width: 16.0),
                Expanded(child: _buildTextField('Zip Code')),
              ],
            ),
            SizedBox(height: 16.0),
            _buildDefaultAddressSwitch(),
            Spacer(),
            _buildAddButton(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Profile tab selected
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        onTap: (index) {
          // Handle bottom nav tap
        },
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget _buildDropDown(String hint) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      hint: Text(hint),
      items: <String>['District 1', 'District 2', 'District 3']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle change
      },
    );
  }

  Widget _buildSpecialNoteField() {
    return TextField(
      maxLength: 200,
      decoration: InputDecoration(
        hintText: 'Enter Special Note (Optional)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        counterText: '0/200', // Custom counter text
      ),
    );
  }

  Widget _buildDefaultAddressSwitch() {
    return SwitchListTile(
      title: Text('Set as default shipping address'),
      value: true, // Initially set as true
      onChanged: (bool value) {
        // Handle switch toggle
      },
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Handle Add action
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text('Add'),
      ),
    );
  }
}

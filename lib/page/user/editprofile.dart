import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String address;

  // Constructor to pass data to EditProfilePage
  EditProfilePage({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Save the edited profile information
  void _saveChanges() {
    Navigator.pop(context, {
      'fullName': _fullNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nama Lengkap', _fullNameController),
            _buildTextField('No Telepon', _phoneNumberController),
            _buildTextField('Alamat', _addressController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

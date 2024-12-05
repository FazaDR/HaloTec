import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halotec/util/config.dart'; // Import apiBaseUrl
import 'package:halotec/util/SharedPreferences.dart'; // Import SharedPreferencesHelper

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  late String _profileImageUrl='';

  // State variables for editable fields
  String _username = '';
  String _email = '';
  String _fullName = '';
  String _phoneNumber = '';
  String _address = '';
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load data from SharedPreferences
  Future<void> _loadProfileData() async {
    final username = await SharedPreferencesHelper.getUsername() ?? 'Unknown Username';
    final profileData = await SharedPreferencesHelper.getUserProfileData();
    final profilePic = profileData['profile_pic'] ?? '/halotec/uploads/profile_pics/mrholder.png';  // Default to placeholder if not available
    
    // Form the full URL using apiBaseUrl
    final profileImageUrl = '$apiBaseUrl$profilePic';

    setState(() {
      _username = username;
      _email = username; // Assuming email is the username
      _fullName = profileData['nama'] ?? 'No Name';
      _phoneNumber = profileData['telpon'] ?? 'No Phone Number';
      _address = profileData['alamat'] ?? 'No Address';
      _gender = profileData['gender'] ?? 'Unknown Gender';
      _profileImageUrl = profileImageUrl;  // Use the full URL for the profile picture
    });
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _profileImageUrl = ''; // Clear URL when a local image is chosen
      });
      print("Picked image: ${pickedFile.path}"); // Debug log
    }
  }

  // Delete the profile picture
  void _deleteProfileImage() {
    setState(() {
      _profileImage = null;
      _profileImageUrl = '$apiBaseUrl/halotec/uploads/profile_pics/mrholder.png'; // Reset to default profile picture
      print("Profile picture deleted!"); // Debug log
    });
  }

  // Build the profile page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 173, 50),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(211, 252, 249, 221),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50.0),
                      ),
                    ),
                  ),
                  // Profile picture and name
                  Positioned(
                    top: 130,
                    left: MediaQuery.of(context).size.width / 2 - 55,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 55.0,
                            backgroundColor: Colors.white, // Border color
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!) // Display local image
                                  : (_profileImageUrl.isNotEmpty
                                      ? NetworkImage(_profileImageUrl) // Display URL image
                                      : null),
                              child: (_profileImage == null && _profileImageUrl.isEmpty)
                                  ? Icon(
                                      Icons.person,
                                      size: 50.0,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0), // Space below the profile picture
                        Text(_fullName,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 120.0),
              // Profile fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileField('Username', _email, editable: false),
                    _buildProfileField('No Telepon', _phoneNumber, editable: false),
                    _buildProfileField('Alamat', _address, editable:false),
                    _buildProfileField('Gender', _gender, editable: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Editable field with pencil icon
  Widget _buildEditableField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                Container(
                  height: 1.0,
                  color: Colors.white,
                ),
                SizedBox(height: 4.0),
                TextField(
                  controller: controller,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Masukkan $label',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Non-editable field
  Widget _buildProfileField(String label, String value, {bool editable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Container(
            height: 1.0,
            color: Colors.white,
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'widget/RoundedInput.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:halotec/util/config.dart';  // Import the config.dart file

class RegisterPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  const RegisterPage({Key? key, required this.onLoginTap}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String gender = 'Laki-laki'; // Default gender

  bool showNameWarning = false;
  bool showAddressWarning = false;
  bool showPhoneWarning = false;
  bool showUsernameWarning = false;
  bool showPasswordWarning = false;
  bool showConfirmPasswordWarning = false;

  String nameWarningText = '';
  String addressWarningText = '';
  String phoneWarningText = '';
  String usernameWarningText = '';
  String passwordWarningText = '';
  String confirmPasswordWarningText = '';

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

Future<void> registerUser() async {
  setState(() {
    // Validate all fields
    showNameWarning = nameController.text.isEmpty;
    showAddressWarning = addressController.text.isEmpty;
    showPhoneWarning = phoneController.text.isEmpty;
    showUsernameWarning = usernameController.text.isEmpty;
    showPasswordWarning = passwordController.text.isEmpty;
    showConfirmPasswordWarning = confirmPasswordController.text.isEmpty;

    // Set warning text for all fields
    nameWarningText = showNameWarning ? "Nama Lengkap harus diisi" : '';
    addressWarningText = showAddressWarning ? "Alamat harus diisi" : '';
    phoneWarningText = showPhoneWarning ? "Nomor Telepon harus diisi" : '';
    usernameWarningText = showUsernameWarning ? "Username harus diisi" : '';
    passwordWarningText = showPasswordWarning ? "Password harus diisi" : '';
    confirmPasswordWarningText = showConfirmPasswordWarning ? "Konfirmasi Password harus diisi" : '';

    // If passwords don't match
    if (passwordController.text != confirmPasswordController.text) {
      showPasswordWarning = true;
      showConfirmPasswordWarning = true;
      passwordWarningText = 'Passwords do not match';
      confirmPasswordWarningText = 'Passwords do not match';
    }
  });

  // If no warnings, proceed with registration
  if (!showNameWarning &&
      !showAddressWarning &&
      !showPhoneWarning &&
      !showUsernameWarning &&
      !showPasswordWarning &&
      !showConfirmPasswordWarning) {
    final url = Uri.parse('$apiBaseUrl/akun/create.php');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": usernameController.text,
        "password": passwordController.text,
        "nama": nameController.text,
        "alamat": addressController.text,
        "telpon": phoneController.text,
        "gender": gender
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        // Reset warning flags if successful
        showNameWarning = false;
        showAddressWarning = false;
        showPhoneWarning = false;
        showUsernameWarning = false;
        showPasswordWarning = false;
        showConfirmPasswordWarning = false;
      });

      print(responseData['message']);
      
      // Show success dialog
      _showSuccessDialog();
    } else {
      setState(() {
        showNameWarning = true;
        nameWarningText = responseData['message'] ?? 'Registration failed.';
      });
    }
  }
}

// Success Dialog
void _showSuccessDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Registrasi berhasil"),
        content: Text("Silahkan melakukan login"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              widget.onLoginTap(); // Navigate to login page
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFBD2A01), Color.fromARGB(255, 125, 27, 0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/flipped.png',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Name Input
                    RoundedInput(
                      controller: nameController,
                      hintText: "Nama Lengkap",
                      icon: Icons.person,
                      showWarning: showNameWarning,
                      warningText: nameWarningText,
                      warningColor: Colors.white,
                    ),
                    // Address Input
                    RoundedInput(
                      controller: addressController,
                      hintText: "Alamat",
                      icon: Icons.home,
                      showWarning: showAddressWarning,
                      warningText: addressWarningText,
                      warningColor: Colors.white,
                    ),
                    // Phone Input
                    RoundedInput(
                      controller: phoneController,
                      hintText: "Nomor Telepon",
                      icon: Icons.phone,
                      showWarning: showPhoneWarning,
                      warningText: phoneWarningText,
                      warningColor: Colors.white,
                    ),
                    // Username Input
                    RoundedInput(
                      controller: usernameController,
                      hintText: "Username",
                      icon: Icons.group,
                      showWarning: showUsernameWarning,
                      warningText: usernameWarningText,
                      warningColor: Colors.white,
                    ),
                    // Password Input
                    RoundedInput(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.lock,
                      isPassword: true,
                      showWarning: showPasswordWarning,
                      warningText: passwordWarningText,
                      warningColor: Colors.white,
                      showVisibilityIcon: false,
                    ),
                    // Confirm Password Input
                    RoundedInput(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      icon: Icons.lock_outlined,
                      isPassword: true,
                      showWarning: showConfirmPasswordWarning,
                      warningText: confirmPasswordWarningText,
                      warningColor: Colors.white,
                      showVisibilityIcon: false,
                    ),
                    // Gender dropdown
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 150,
                        ),
                        child: DropdownButtonFormField<String>(
                          hint: Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          value: gender,
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue ?? 'Laki-laki';
                            });
                          },
                          items: <String>['Laki-laki', 'Perempuan']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 19),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login Redirect
                    Row(
                      children: [
                        Text(
                          '     Sudah memiliki akun? ',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: widget.onLoginTap,
                          child: Text(
                            'Masuk disini',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Register Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 149, 0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: registerUser,
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

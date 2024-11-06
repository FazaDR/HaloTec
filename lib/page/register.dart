import 'package:flutter/material.dart';
import 'widget/RoundedInput.dart';

class RegisterPage extends StatelessWidget {
  final VoidCallback onLoginTap;

  const RegisterPage({Key? key, required this.onLoginTap}) : super(key: key);

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
                    SizedBox(height: 0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 20),
                    RoundedInput("Nama Lengkap", Icons.person),
                    SizedBox(height: 20),
                    RoundedInput("Alamat", Icons.home),
                    SizedBox(height: 20),
                    RoundedInput("Nomor Telepon", Icons.phone),
                    SizedBox(height: 20),
                    RoundedInput("Username", Icons.group),
                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              obscureText: true, // Make the password input obscured
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 20), // Add more space here between password and dropdown
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              obscureText: true, // Make the confirmation password input obscured
                              style: TextStyle(fontSize: 12, color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Konfirmasi Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.lock_outline,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 150,  // Set a maximum width to make the dropdown shorter
                        ),
                        child: DropdownButtonFormField<String>(
                          hint: Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.grey,  // Set hint text color to grey
                              fontSize: 12,        // Set hint text size to 12
                            ),
                          ),
                          onChanged: (String? newValue) {
                            // No need to manage the state of the selected value
                          },
                          items: <String>['Laki-laki', 'Perempuan']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 12),  // Font size set to 12 for items
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 19), // Adjust padding to center the hint text
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12), // Grey hint text with font size 12
                            alignLabelWithHint: true, // Align label with hint text
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10), // Space below the dropdown

                    Row(
                      children: [
                        Text(
                          '     Sudah memiliki akun? ',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: onLoginTap,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 149, 0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            print("Register button tapped");
                          },
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
                    SizedBox(height: 20),
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

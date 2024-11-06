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
                    RoundedInput("E-Mail", Icons.email),
                    SizedBox(height: 20),
                    RoundedInput("Nama Lengkap", Icons.person),
                    SizedBox(height: 20),
                    RoundedInput("Alamat", Icons.home),
                    SizedBox(height: 20),
                    RoundedInput("Nomor Telepon", Icons.phone),
                    SizedBox(height: 20),
                    RoundedInput("Nama Referal (opsional)", Icons.group),
                    SizedBox(height: 20),
                    RoundedInput("Password", Icons.lock),
                    SizedBox(height: 20),
                    RoundedInput("Konfirmasi Password", Icons.lock_outline),
                    SizedBox(height: 10),
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

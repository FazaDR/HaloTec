import 'package:flutter/material.dart';
import 'widget/RoundedInput.dart';
import 'package:halotec/page/home/home.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const LoginPage({Key? key, required this.onRegisterTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 224, 173),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/login.png',
              height: MediaQuery.of(context).size.height * 0.375,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' Login',
                  style: TextStyle(fontSize: 40, color: Colors.black),
                ),
                SizedBox(height: 30),
                RoundedInput("Username", Icons.person),
                SizedBox(height: 30),
                RoundedInput("Password", Icons.key),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '     Belum memiliki akun? ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: onRegisterTap,
                      child: Text(
                        'Daftar disini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 131, 70, 48),
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
                      color: Color(0xFFA5300F),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

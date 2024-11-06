import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _pageController = PageController();

  void _goToRegister() {
    _pageController.animateToPage(
      1, // Go to the Register page
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _goToLogin() {
    _pageController.animateToPage(
      0, // Go back to the Login page
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical, // Set to vertical scroll for up/down effect
        physics: NeverScrollableScrollPhysics(), // Disable swipe gesture to control transition programmatically
        children: [
          LoginPage(onRegisterTap: _goToRegister), // Pass function to navigate to Register
          RegisterPage(onLoginTap: _goToLogin),     // Pass function to navigate to Login
        ],
      ),
    );
  }
}
